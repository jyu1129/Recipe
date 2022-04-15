//
//  XCTestCaseExtension.swift
//  RecipeUITests
//
//  Created by Justin on 14/04/2022.
//

import XCTest

extension XCTestCase {
    func tapElementAndWaitForKeyboardToAppear(element: XCUIElement) {
        let keyboard = XCUIApplication().keyboards.element
        while (true) {
            element.tap()
            if keyboard.exists {
                break;
            }
            RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 0.5) as Date)
        }
    }
}
