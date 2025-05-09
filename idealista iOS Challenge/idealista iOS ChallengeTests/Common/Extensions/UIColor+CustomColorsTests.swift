//
//  UIColor+CustomColorsTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge
import SwiftUI

final class UIColorCustomColorsTests: XCTestCase {
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {}
    
    func testUIColors() throws {
        XCTAssertNotNil(UIColor.primaryColor, "Primary color should exist")
        XCTAssertNotNil(UIColor.secondaryColor, "Secondary color should exist")
        XCTAssertNotNil(UIColor.accentColor, "Accent color should exist")
        XCTAssertNotNil(UIColor.backgroundColor, "Background color should exist")
        XCTAssertNotNil(UIColor.primaryTextColor, "Primary text color should exist")
        XCTAssertNotNil(UIColor.secondaryTextColor, "Secondary text color should exist")
        XCTAssertNotNil(UIColor.navigationColor, "Navigation color should exist")
        XCTAssertNotNil(UIColor.cellBackgroundColor, "Cell background color should exist")
    }
    
    func testSwiftUIColors() throws {
        XCTAssertNotNil(Color.primaryColor, "Primary color should exist")
        XCTAssertNotNil(Color.secondaryColor, "Secondary color should exist")
        XCTAssertNotNil(Color.accentAppColor, "Accent color should exist")
        XCTAssertNotNil(Color.backgroundColor, "Background color should exist")
        XCTAssertNotNil(Color.primaryTextColor, "Primary text color should exist")
        XCTAssertNotNil(Color.secondaryTextColor, "Secondary text color should exist")
        XCTAssertNotNil(Color.navigationColor, "Navigation color should exist")
        XCTAssertNotNil(Color.cellBackgroundColor, "Cell background color should exist")
    }
    
}
