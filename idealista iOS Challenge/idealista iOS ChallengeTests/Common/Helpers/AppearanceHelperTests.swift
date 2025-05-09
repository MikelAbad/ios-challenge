//
//  AppearanceHelperTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge

final class AppearanceHelperTests: XCTestCase {
    
    private var originalStandardAppearance: UINavigationBarAppearance?
    private var originalScrollEdgeAppearance: UINavigationBarAppearance?
    private var originalTintColor: UIColor?
    
    override func setUpWithError() throws {
        originalStandardAppearance = UINavigationBar.appearance().standardAppearance
        originalScrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
        originalTintColor = UINavigationBar.appearance().tintColor
    }
    
    override func tearDownWithError() throws {
        UINavigationBar.appearance().standardAppearance = originalStandardAppearance ?? UINavigationBarAppearance()
        UINavigationBar.appearance().scrollEdgeAppearance = originalScrollEdgeAppearance
        UINavigationBar.appearance().tintColor = originalTintColor
    }
    
    func testNavigationBarConfiguration() throws {
        AppearanceHelper.configure()
        
        let navBar = UINavigationBar.appearance()
        
        XCTAssertNotNil(navBar.standardAppearance, "Standard appearance should not be nil")
        XCTAssertEqual(navBar.standardAppearance.backgroundColor, .navigationColor, "Background color should be .navigationColor")
        
        let titleAttributes = navBar.standardAppearance.titleTextAttributes
        XCTAssertNotNil(titleAttributes, "Title attributes should not be nil")
        XCTAssertEqual(titleAttributes[.foregroundColor] as? UIColor, .primaryTextColor, "Text color should be .primaryTextColor")
        
        let expectedFont = UIFont.preferredFont(forTextStyle: .headline)
        let actualFont = titleAttributes[.font] as? UIFont
        XCTAssertNotNil(actualFont, "Font should not be nil")
        XCTAssertEqual(actualFont?.fontName, expectedFont.fontName, "Font name should be the same")
        XCTAssertEqual(actualFont?.pointSize, expectedFont.pointSize, "Font size should be the same")
        
        XCTAssertNotNil(navBar.scrollEdgeAppearance, "Scroll edge appearance should not be nil")
        XCTAssertEqual(navBar.tintColor, .accentColor, "Tint color should be .accentColor")
    }
    
    func testNavigationBarNotConfigured() throws {
        let navBar = UINavigationBar.appearance()
        
        XCTAssertNotEqual(navBar.standardAppearance.backgroundColor, .navigationColor, "Background color should not be .navigationColor")
        
        let titleAttributes = navBar.standardAppearance.titleTextAttributes
        XCTAssertNotEqual(titleAttributes[.foregroundColor] as? UIColor, .primaryTextColor, "Text color should not be .primaryTextColor")
    }
    
}
