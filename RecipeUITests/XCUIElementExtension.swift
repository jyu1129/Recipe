//
//  XCUIElementExtension.swift
//  RecipeUITests
//
//  Created by Justin on 14/04/2022.
//

import XCTest

extension XCUIElement {
    func dismissKeyboardIfPresent() {
        if keys.element(boundBy: 0).exists {
            typeText("\n")
        }
    }
}
