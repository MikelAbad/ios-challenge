//
//  String+LocalizableTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge

final class StringLocalizableTests: XCTestCase {
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {}
    
    func testLocalized() throws {
        XCTAssertEqual("alert.ok".localized(), "OK")
    }
    
    func testLocalizedWrongKey() throws {
        XCTAssertEqual("wrong.key".localized(), "wrong.key")
    }
    
    func testLocalizedParameters() throws {
        XCTAssertEqual(String(format: "propertyDetail.address".localized(), "Calle", "Barrio", "Ciudad"), "Calle - Barrio, Ciudad")
    }
}
