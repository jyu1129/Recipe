//
//  RecipeUITests.swift
//  RecipeUITests
//
//  Created by Justin on 11/04/2022.
//

import XCTest

class RecipeUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testAddRecipe() {
        app.buttons["Add"].tap()
        tapElementAndWaitForKeyboardToAppear(element: app.textFields["Recipe Name"])
        app.typeText("Test Recipe Name")
        tapElementAndWaitForKeyboardToAppear(element: app.textFields["Ingredient #1"])
        app.typeText("Test Ingredient #1")
        tapElementAndWaitForKeyboardToAppear(element: app.textFields["Step #1"])
        app.typeText("Test Step #1")
        app.dismissKeyboardIfPresent()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "🦀")
        app.buttons["buttonAdd"].tap()
        app.buttons["alertOK"].tap()
        app.waitForExistence(timeout: 1)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.staticTexts["Test Recipe Name"].exists)
    }
    
    func testModifyRecipe() {
        let original = "Test Recipe Name"
        let modified = "Modified Test Recipe Name"
        
        XCTAssertTrue(app.staticTexts[original].exists)
        app.staticTexts[original].tap()
        app.buttons["editButton"].tap()
        tapElementAndWaitForKeyboardToAppear(element: app.textFields["Recipe Name"])
        app.textFields["Recipe Name"].press(forDuration: 2)
        app.menuItems["Select All"].tap()
        app.typeText(modified)
        app.dismissKeyboardIfPresent()
        app.buttons["buttonAdd"].tap()
        app.buttons["alertOK"].tap()
        app.waitForExistence(timeout: 1)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.staticTexts[modified].exists)
    }
    
    func testDeleteRecipe() {
        let original = "Modified Test Recipe Name"
        
        XCTAssertTrue(app.staticTexts[original].exists)
        app.staticTexts[original].tap()
        app.buttons["deleteButton"].tap()
        app.buttons["alertOK"].tap()
        XCTAssertFalse(app.staticTexts[original].exists)
    }
}

extension RecipeUITests {
    
}
