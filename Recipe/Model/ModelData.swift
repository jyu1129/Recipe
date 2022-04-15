//
//  ModelData.swift
//  Recipe
//
//  Created by Justin on 12/04/2022.
//

import Foundation
import XMLParsing

final class ModelData: ObservableObject {
    var modelRecipeTypes: RecipeTypes = load("recipeTypes.xml")
    var modelRecipes: Recipes = Recipes()
    
//    var features: [Landmark] {
//        landmarks.filter { $0.isFeatured }
//    }
//
//    var categories: [String: [Landmark]] {
//        Dictionary(
//            grouping: landmarks,
//            by: { $0.category.rawValue }
//        )
//    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        return try XMLDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
