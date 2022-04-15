//
//  AddRecipeViewController.swift
//  Recipe
//
//  Created by Justin on 13/04/2022.
//

import FormTextField
import PhotosUI
import UIKit

enum ModifyRecipeMode {
    case edit
    case create
}

class ModifyRecipeViewController: BaseViewController {
    let labelTitle = UILabel()
    let scrollViewContainer = BaseScrollView(direction: .vertical)
    let stackViewContainer = UIStackView()
    let imageViewRecipe = UIImageView()
    let imageViewCamera = UIImageView()
    let labelName = UILabel()
    let textFieldName = FormTextField()
    let labelIngredients = UILabel()
    let stackViewGroupedAddTextFieldIngredient = GroupedAddTextFieldStackView(placeholder: "Ingredient")
    let labelSteps = UILabel()
    let stackViewGroupedAddTextFieldStep = GroupedAddTextFieldStackView(placeholder: "Step")
    let pickerViewRecipeType = UIPickerView()
    let buttonAdd = UIButton(type: .contactAdd)

    let modelData = ModelData()
    lazy var recipeTypes: [String] = {
        modelData.modelRecipeTypes.category
    }()
    
    var mode: ModifyRecipeMode = .create
    var recipe: Recipe?
    
    required init(mode: ModifyRecipeMode, recipe: Recipe? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.mode = mode
        if let recipe = recipe, mode == .edit {
            self.recipe = recipe
            labelTitle.text = "Edit Recipe"
            imageViewRecipe.image = UIImage(data: recipe.image, scale: 1.0)
            textFieldName.text = recipe.name
            stackViewGroupedAddTextFieldIngredient.stackViewAddTextFields[0].textField.text = recipe.ingredients[0]
            for i in 0..<recipe.ingredients.count - 1 {
                stackViewGroupedAddTextFieldIngredient.stackViewAddTextFields[i].buttonAddAction()
                stackViewGroupedAddTextFieldIngredient.stackViewAddTextFields[i + 1].textField.text = recipe.ingredients[i + 1]
            }
            stackViewGroupedAddTextFieldStep.stackViewAddTextFields[0].textField.text = recipe.steps[0]
            for i in 0..<recipe.steps.count - 1 {
                stackViewGroupedAddTextFieldStep.stackViewAddTextFields[i].buttonAddAction()
                stackViewGroupedAddTextFieldStep.stackViewAddTextFields[i + 1].textField.text = recipe.steps[i + 1]
            }
        } else {
            labelTitle.text = "Add Recipe"
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        commonInit()
        
        super.viewDidLoad()
    }

    private func commonInit() {
        setup()
        addView()
        addConstraint()
    }

    private func setup() {
        imageViewRecipe.image = UIImage(named: "apple")
        _ = imageViewRecipe.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            ImagePickerManager().pickImage(self) { image in
                self.imageViewRecipe.image = image
            }
        }
        
        imageViewCamera.image = UIImage(named: "camera")
        imageViewCamera.contentMode = .scaleAspectFit

        labelTitle.font = .systemFont(ofSize: 33, weight: .medium)
        labelTitle.textAlignment = .center

        stackViewContainer.axis = .vertical
        stackViewContainer.alignment = .fill
        stackViewContainer.distribution = .fill
        stackViewContainer.spacing = margin

        imageViewRecipe.contentMode = .scaleAspectFit

        labelName.text = "Recipe Name"
        
        var validation = Validation()
        validation.minimumLength = 1
        textFieldName.placeholder = "Recipe Name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.inputValidator = InputValidator(validation: validation)
        textFieldName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        labelIngredients.text = "Ingredients"
        
        labelSteps.text = "Steps"
        
        pickerViewRecipeType.delegate = self
        pickerViewRecipeType.dataSource = self
        if mode == .edit {
            if let recipe = recipe {
                let categories = modelData.modelRecipeTypes.category
                if let row = categories.firstIndex(of: recipe.category) {
                    pickerViewRecipeType.selectRow(row, inComponent: 0, animated: false)
                }
            }
        }

        buttonAdd.addTarget(self, action: #selector(buttonAddAction), for: .touchUpInside)
        buttonAdd.accessibilityLabel = "buttonAdd"
    }

    private func addView() {
        safeAreaView.addSubview(labelTitle)
        safeAreaView.addSubview(scrollViewContainer)
        scrollViewContainer.contentView.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(imageViewRecipe)
        imageViewRecipe.addSubview(imageViewCamera)
        stackViewContainer.addArrangedSubview(labelName)
        stackViewContainer.addArrangedSubview(textFieldName)
        stackViewContainer.addArrangedSubview(labelIngredients)
        stackViewContainer.addArrangedSubview(stackViewGroupedAddTextFieldIngredient)
        stackViewContainer.addArrangedSubview(labelSteps)
        stackViewContainer.addArrangedSubview(stackViewGroupedAddTextFieldStep)
        stackViewContainer.addArrangedSubview(pickerViewRecipeType)
        safeAreaView.addSubview(buttonAdd)
    }

    private func addConstraint() {
        labelTitle.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        scrollViewContainer.snp.makeConstraints { make in
            make.top.equalTo(labelTitle.snp.bottom).offset(margin)
            make.leading.trailing.equalToSuperview()
        }

        stackViewContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(margin * 2)
            make.trailing.equalToSuperview().inset(margin * 2)
        }

        imageViewRecipe.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        imageViewCamera.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.width.height.equalTo(50)
        }

        buttonAdd.snp.makeConstraints { make in
            make.top.equalTo(scrollViewContainer.snp.bottom).offset(margin)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension ModifyRecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        recipeTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        recipeTypes[row]
    }
}

extension ModifyRecipeViewController {
    @objc private func buttonAddAction() {
        if textFieldName.validate() && stackViewGroupedAddTextFieldIngredient.validate() && stackViewGroupedAddTextFieldStep.validate() {
            let alert = UIAlertController(title: "Alert", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            let alertOK = UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                guard let self = self else { return }
                if self.mode == .create {
                    if let textName = self.textFieldName.text, let image = self.imageViewRecipe.image {
                        let recipe = Recipe(name: textName,
                                            ingredients: self.stackViewGroupedAddTextFieldIngredient.getTexts(),
                                            steps: self.stackViewGroupedAddTextFieldStep.getTexts(),
                                            category: self.recipeTypes[self.pickerViewRecipeType.selectedRow(inComponent: 0)],
                                            image: image.data())
                        
                        self.modelData.modelRecipes.insertRecipe(recipe: recipe)
                        self.pushToDisplay(recipe: recipe)
                    }
                } else {
                    if let recipe = self.recipe {
                        if let textName = self.textFieldName.text, let image = self.imageViewRecipe.image {
                            let newRecipe = Recipe(name: textName,
                                                   ingredients: self.stackViewGroupedAddTextFieldIngredient.getTexts(),
                                                   steps: self.stackViewGroupedAddTextFieldStep.getTexts(),
                                                   category: self.recipeTypes[self.pickerViewRecipeType.selectedRow(inComponent: 0)], image: image.data())
                            
                            self.modelData.modelRecipes.modifyRecipe(recipeToUpdate: recipe, newValue: newRecipe)
                            self.pushToDisplay(recipe: newRecipe)
                        }
                    }
                }
            })
            alertOK.accessibilityLabel = "alertOK"
            alert.addAction(alertOK)
            present(alert, animated: true, completion: nil)
        } else {
            showToast(message: "Not finished!", font: UIFont.systemFont(ofSize: 13))
        }
    }
    
    private func pushToDisplay(recipe: Recipe) {
        if let navStack = navigationController?.viewControllers {
            var filtered = navStack.filter { vc in
                
                return vc is RecipeListViewController
            }
            
            let vc = DisplayRecipeViewController()
            vc.recipe = recipe
            
            filtered.append(vc)
            
            navigationController?.setViewControllers(filtered, animated: true)
        }
    }
}
