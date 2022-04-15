//
//  RecipeListViewController.swift
//  Recipe
//
//  Created by Justin on 11/04/2022.
//

import UIKit
import SnapKit
import RealmSwift

class RecipeListViewController: BaseViewController {
    let modelData = ModelData()
    lazy var recipeTypes: [String] = {
        modelData.modelRecipeTypes.category
    }()
    lazy var recipes: Results<Recipe> = {
        modelData.modelRecipes.retrieveRecipes()
    }()
    
    let labelFilter = UILabel()
    let pickerViewRecipeType = UIPickerView()
    let tableViewRecipe = UITableView()
    
    private func commonInit() {
        setup()
        addView()
        addConstraint()
    }
    
    override func viewDidLoad() {
        commonInit()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipes = modelData.modelRecipes.retrieveRecipes()
        tableViewRecipe.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    private func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemAddAction))
        
        labelFilter.text = "Filter by:"
        
        pickerViewRecipeType.delegate = self
        pickerViewRecipeType.dataSource = self
        
        tableViewRecipe.backgroundColor = .clear
        tableViewRecipe.delegate = self
        tableViewRecipe.dataSource = self
        tableViewRecipe.register(RecipeTableViewCell.self, forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
    private func addView() {
        safeAreaView.addSubview(labelFilter)
        safeAreaView.addSubview(pickerViewRecipeType)
        safeAreaView.addSubview(tableViewRecipe)
    }
    
    private func addConstraint() {
        labelFilter.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
        }
        
        pickerViewRecipeType.snp.makeConstraints { make in
            make.top.equalTo(labelFilter.snp.bottom)
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
        }
        
        tableViewRecipe.snp.makeConstraints { make in
            make.top.equalTo(pickerViewRecipeType.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections = 0
        // Show No data if there is no data
        if !recipes.isEmpty {
            tableViewRecipe.separatorStyle = .singleLine
            numOfSections = 1
            tableViewRecipe.backgroundView = nil
        } else {
            let labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: tableViewRecipe.bounds.size.width, height: tableViewRecipe.bounds.size.height))
            labelNoData.text = "No data availbale"
            labelNoData.textAlignment = .center
            tableViewRecipe.backgroundView = labelNoData
            tableViewRecipe.separatorStyle = .none
        }
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell") as? RecipeTableViewCell
        
        guard let cell = cell else {
            return UITableViewCell()
        }
        
        cell.recipe = recipes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DisplayRecipeViewController()
        vc.recipe = recipes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RecipeListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        recipeTypes.count + 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "All"
        } else {
            return recipeTypes[row - 1]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            recipes = modelData.modelRecipes.retrieveRecipes()
        } else {
            recipes = modelData.modelRecipes.retrieveRecipes().filter("category == %@", recipeTypes[row - 1])
        }

        tableViewRecipe.reloadData()
    }
}

extension RecipeListViewController {
    @objc private func barButtonItemAddAction() {
        let vc = ModifyRecipeViewController(mode: .create)
        navigationController?.pushViewController(vc, animated: true)
    }
}
