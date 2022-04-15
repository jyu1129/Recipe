//
//  RecipeModel.swift
//  Recipe
//
//  Created by Justin on 11/04/2022.
//

import Foundation
import RealmSwift

class Recipes: Object {
    @Persisted var recipes: List<Recipe> = List()

    func insertRecipe(recipe taskToInsert: Recipe) {
        let localRealm = try! Realm()
        try! localRealm.write({
            localRealm.add(taskToInsert)
        })
    }

    func retrieveRecipes() -> Results<Recipe> {
        let localRealm = try! Realm()
        return localRealm.objects(Recipe.self)
    }

    func modifyRecipe(recipeToUpdate taskToUpdate: Recipe, newValue: Recipe) {
        let localRealm = try! Realm()
        try! localRealm.write {
            taskToUpdate.name = newValue.name
            taskToUpdate.category = newValue.category
            taskToUpdate.ingredients.removeAll()
            taskToUpdate.ingredients.append(objectsIn: newValue.ingredients)
            taskToUpdate.steps.removeAll()
            taskToUpdate.steps.append(objectsIn: newValue.steps)
            taskToUpdate.image = newValue.image
        }
    }

    func deleteRecipe(recipe taskToDelete: Recipe) {
        let localRealm = try! Realm()
        try! localRealm.write {
            localRealm.delete(taskToDelete)
        }
    }
}

class Recipe: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    let ingredients = List<String>()
    let steps = List<String>()
    @objc dynamic var category = ""
    @objc dynamic var image = Data()

    override class func primaryKey() -> String? {
        return "id"
    }

    override init() {
    }

    init(name: String, ingredients: List<String>, steps: List<String>, category: String, image: Data) {
        self.name = name
        self.ingredients.append(objectsIn: ingredients)
        self.steps.append(objectsIn: steps)
        self.category = category
        self.image = image
    }
}
