//
//  DisplayRecipeViewController.swift
//  Recipe
//
//  Created by Justin on 14/04/2022.
//

import UIKit

class DisplayRecipeViewController: BaseViewController {
    let scrollViewContainer = BaseScrollView(direction: .vertical)
    let stackViewContainer = UIStackView()
    let imageViewRecipe = UIImageView()
    let labelName = UILabel()
    let labelIngredient = UILabel()
    let labelIngredients = UILabel()
    let labelStep = UILabel()
    let labelSteps = UILabel()

    let modelData = ModelData()
    var recipe: Recipe? {
        didSet {
            if let recipe = recipe {
                print(recipe)
                imageViewRecipe.image = UIImage(data: recipe.image, scale: 1.0)
                labelName.text = "\(recipe.category) \(recipe.name)"
                labelIngredients.addBulletPoints(stringList: Array(recipe.ingredients), font: .systemFont(ofSize: 16))
                labelSteps.addNumberedList(stringList: Array(recipe.steps), font: .systemFont(ofSize: 16))
            }
        }
    }

    private func commonInit() {
        setup()
        addView()
        addConstraint()
    }

    override func viewDidLoad() {
        commonInit()

        super.viewDidLoad()
    }

    private func setup() {
        navigationController?.isToolbarHidden = false

        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(barButtonSystemItem: .edit , target: self, action: #selector(editAction)))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAction)))
        items[0].accessibilityLabel = "editButton"
        items[2].accessibilityLabel = "deleteButton"

        toolbarItems = items

        stackViewContainer.axis = .vertical
        stackViewContainer.alignment = .fill
        stackViewContainer.distribution = .fill
        stackViewContainer.spacing = margin

        labelName.font = .systemFont(ofSize: 33)
        labelName.textAlignment = .center
        labelName.adjustsFontSizeToFitWidth = true

        imageViewRecipe.contentMode = .scaleAspectFit

        labelIngredient.font = .systemFont(ofSize: 25)
        labelIngredient.text = "Ingredients:"
        
        labelIngredients.numberOfLines = 0

        labelStep.font = .systemFont(ofSize: 25)
        labelStep.text = "Steps:"
        
        labelSteps.numberOfLines = 0
    }

    private func addView() {
        safeAreaView.addSubview(scrollViewContainer)
        scrollViewContainer.contentView.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(labelName)
        stackViewContainer.addArrangedSubview(imageViewRecipe)
        stackViewContainer.addArrangedSubview(labelIngredient)
        stackViewContainer.addArrangedSubview(labelIngredients)
        stackViewContainer.addArrangedSubview(labelStep)
        stackViewContainer.addArrangedSubview(labelSteps)
    }

    private func addConstraint() {
        scrollViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackViewContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
        }

        imageViewRecipe.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }
}

extension DisplayRecipeViewController {
    @objc private func editAction() {
        if let recipe = recipe {
            let vc = ModifyRecipeViewController(mode: .edit, recipe: recipe)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func deleteAction() {
        if let recipe = recipe {
            let alert = UIAlertController(title: "Alert", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            let alertOK = UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                guard let self = self else { return }
                self.modelData.modelRecipes.deleteRecipe(recipe: recipe)
                self.navigationController?.popViewController(animated: true)
            })
            alertOK.accessibilityLabel = "alertOK"
            alert.addAction(alertOK)
            present(alert, animated: true, completion: nil)
        }
    }
}
