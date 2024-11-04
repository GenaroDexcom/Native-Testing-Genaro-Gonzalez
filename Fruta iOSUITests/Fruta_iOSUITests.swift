//
//  Fruta_iOSUITests.swift
//  Fruta iOSUITests
//
//  Created by Hugo Landines on 01/10/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import XCTest
import Fruta_iOS
import SwiftUI
import Foundation
final class Fruta_iOSUITests: XCTestCase {
    let smoothies = ["berry-blue","carrot-chops","hulking-lemonade", "kiwi-cutie","lemonberry","love-you-berry-much","mango-jambo","one-in-a-melon","papas-papaya", "peanut-butter-cup", "pina-y-coco", "sailor-man", "thats-a-smore", "thats-berry-bananas", "tropical-blue"]
    let ingredients = ["Ingredients: Orange, blueberry, and avocado.", "Ingredients: Orange, carrot, and mango.", "Ingredients: Lemon, spinach, and avocado.", "Ingredients: Kiwi, orange, and spinach.", "Ingredients: Raspberry, strawberry, and lemon.", "Ingredients: Strawberry, blueberry, and raspberry.", "Ingredients: Mango and pineapple.", "Ingredients: Watermelon and raspberry.", "Ingredients: Orange, mango, and papaya.", "Ingredients: Almond Milk, banana, chocolate, and peanut butter.", "Ingredients: Pineapple, almond milk, and coconut.", "Ingredients: Orange and spinach.", "Ingredients: Almond Milk, coconut, and chocolate.", "Ingredients: Almond Milk, banana, and strawberry.", "Ingredients: Almond Milk, banana, blueberry, and mango."]
    
    let calories = ["520 kilocalories", "230 kilocalories", "170 kilocalories", "210 kilocalories", "140 kilocalories", "210 kilocalories", "140 kilocalories", "130 kilocalories", "210 kilocalories", "460 kilocalories", "320 kilocalories", "170 kilocalories", "240 kilocalories", "580 kilocalories", "490 kilocalories"]
    
    let twoSmoothies = ["hulking-lemonade", "tropical-blue"]
    let descriptions = ["This is not just any lemonade. It will give you powers you'll struggle to control!", "A delicious blend of tropical fruits and blueberries will have you sambaing around like you never knew you could!"]
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    // Verify entire list of smoothies
    func testExercise1() {
        let app = XCUIApplication()
        app.launch()
        for ((smoothie, ingredient), calorie) in zip(zip(smoothies, ingredients), calories) {
            do {
                let title = app.staticTexts["title-\(smoothie)"]
                let image = app.images["image-\(smoothie)"]
                let ingredients = app.staticTexts["ingredients-\(smoothie)"]
                let calories = app.staticTexts["energy-\(smoothie)"]
                let formattedName = formatString(smoothie)
                print("Formatted Name: \(formattedName)")
              
                if !title.exists {
                    app.swipeUp()
                } else {
                    print("Title \(smoothie) is present")
                    let labels = app.staticTexts.element(matching: .any, identifier: "title-\(smoothie)").label
                    let ingredientLabel = app.staticTexts.element(matching: .any, identifier: "ingredients-\(smoothie)").label
                    let calorieLabel = app.staticTexts.element(matching: .any, identifier: "energy-\(smoothie)").label
                    if (labels != formattedName) {
                        print("Fail: Label is different from FormattedNames")
                        print( " \(formattedName) is mispelled as \(labels)")
                    } else {
                        print("Success: Labels is equal to FormattedNames")
                        XCTAssertEqual(labels, formattedName)
                        print("Label: \(labels)")
                        print("Name: \(formattedName)")
                    }
                    XCTAssert(title.exists)
                    XCTAssertTrue(image.exists, "The image for \(smoothie) is not visible")
                    let imageLabel = image.identifier
                    XCTAssertEqual(imageLabel, "image-\(smoothie)")
                    XCTAssert(ingredients.exists)
                    XCTAssert(calories.exists)
                    print("Ingredients Label: \(ingredientLabel)")
                    print("Ingredients: \(ingredient)")
                    XCTAssertEqual(ingredientLabel, ingredient)
                    print("Energy Label: \(calorieLabel)")
                    print("Energy: \(calorie)")
                    XCTAssertEqual(calorieLabel, calorie)
                }
            }
        }
    }
    
    //Select two smoothies to verify their description in detail screen
    func testExercise2() {
        let app = XCUIApplication()
        app.launch()
        for (smoothie, description) in zip(twoSmoothies, descriptions) {
            do {
                let title = app.staticTexts["title-\(smoothie)"]
                var smoothieDesc = ""
                if (!title.exists) {
                    app.swipeUp()
                }
                title.tap()
                app.swipeUp()
                smoothieDesc = app.staticTexts.element(matching: .any, identifier: "description-\(smoothie)").label
                print("Desc Label: \(smoothieDesc)")
                print("Desc from array: \(description)")
                XCTAssertEqual(smoothieDesc, description)
                app.navigationBars.buttons["Menu"].tap()
                
            }
        }
    }
    
    // Verify favorites logic: Enter to favorites screen and verify empty-favorites-message
    func testExercise3A() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Favorites"].tap()
        let displayMessage = app.staticTexts["empty-favorites-message"]
        XCTAssert(displayMessage.exists)
    }
    
    // Verify favorites logic: Select smoothie to add to favorites and verify its display
    func testExercise3B() {
        let app = XCUIApplication()
        app.launch()
        let title = app.staticTexts["title-\(smoothies[1])"]
        title.tap()
        print("title Label: \(title)")
        
        let favorite = app.buttons["favorite-button-\(smoothies[1])"]
        favorite.tap()
        app.navigationBars.buttons["Menu"].tap()
        app.buttons["Favorites"].tap()
        XCTAssert(title.exists)
        app.navigationBars.buttons["Menu"].tap()
    }
    
    //Test search functionality: Type word "orange" and verify results
    func testExercise4() {
        let app = XCUIApplication()
        app.launch()
        let searchBar = app.searchFields["Search"]
        searchBar.tap();
        searchBar.typeText("orange")
        for ((smoothie, ingredient), calorie) in zip(zip(smoothies, ingredients), calories) {
            do {
                let title = app.staticTexts["title-\(smoothie)"]
                let image = app.images["image-\(smoothie)"]
                let ingredients = app.staticTexts["ingredients-\(smoothie)"]
                let calories = app.staticTexts["energy-\(smoothie)"]
                let formattedName = formatString(smoothie)
                print("Formatted Name: \(formattedName)")
                let orange = "Orange"
                if (ingredient.range(of: orange, options: .caseInsensitive) == nil) {
                    print("Ingredients without orange \(ingredient.description)")
                } else {
                    print("Ingredients with orange \(ingredient.description)")
                    print("Title \(smoothie) is present")
                   let labels = app.staticTexts.element(matching: .any, identifier: "title-\(smoothie)").label
                   let ingredientLabel = app.staticTexts.element(matching: .any, identifier: "ingredients-\(smoothie)").label
                   let calorieLabel = app.staticTexts.element(matching: .any, identifier: "energy-\(smoothie)").label
                    if (labels != formattedName) {
                        print("Fail: Label is different from FormattedNames")
                        print( "\(formattedName) is mispelled as \(labels)")
                    } else {
                        print("Success: Labels is equal to FormattedNames")
                        XCTAssertEqual(labels, formattedName)
                        print("Label: \(labels)")
                        print("Name: \(formattedName)")
                    }
                    XCTAssert(title.exists)
                    XCTAssert(image.exists)
                    XCTAssert(ingredients.exists)
                    XCTAssert(calories.exists)
                    print("Ingredients Label: \(ingredientLabel)")
                    print("Ingredients: \(ingredient)")
                    XCTAssertEqual(ingredientLabel, ingredient)
                    print("Energy Label: \(calorieLabel)")
                    print("Energy: \(calorie)")
                    XCTAssertEqual(calorieLabel, calorie)
                }
            }
        }
    }
    
    
    func formatString(_ smoothie: String) -> String {
        let words = smoothie.split(separator: "-")
        
        let addExclamation = words.first?.lowercased() == "thats"
        
        let transformedWord = words.enumerated().map() { index, word in
            if index == 0 {
                if word.lowercased() == "pina" {
                    return "Piña"
                }
                if word.hasSuffix("s") {
                    return word.capitalized.dropLast() + "'s"
                }
            }
            return word.count < 3 ? word.lowercased() : word.capitalized
        }
        
        var result = transformedWord.joined(separator: " ")
        
        if (addExclamation) {
            result += "!"
        }
        
        return result
    }
}
