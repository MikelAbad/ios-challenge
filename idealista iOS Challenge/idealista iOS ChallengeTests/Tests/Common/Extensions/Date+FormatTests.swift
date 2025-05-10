//
//  Date+FormatTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge

final class DateFormatTests: XCTestCase {
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {}
    
    func testRelativeFormatToday() {
        let today = Date()
        let formattedDate = today.relativeFormat()
        XCTAssertEqual(formattedDate, "date.today".localized(), "Date should be 'Today'")
    }
    
    func testRelativeFormatYesterday() throws {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let formattedDate = yesterday.relativeFormat()
        XCTAssertEqual(formattedDate, "date.yesterday".localized(), "Date should be 'Yesterday'")
    }
    
    func testRelativeFormatDaysAgo() throws {
        for daysAgo in 2...9 {
            let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
            let formattedDate = date.relativeFormat()
            let expected = String(format: "date.daysAgo".localized(), daysAgo)
            XCTAssertEqual(formattedDate, expected, "Date should be '\(expected)'")
        }
    }
    
    func testRelativeFormatOlderDates() throws {
        let olderDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        let formattedDate = olderDate.relativeFormat()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let expected = formatter.string(from: olderDate)
        
        XCTAssertEqual(formattedDate, expected, "Date should be in 'dd-MM-yyyy' format")
    }
    
    func testShortFormat() throws {
        let dateComponents = DateComponents(year: 2025, month: 3, day: 15)
        let date = Calendar.current.date(from: dateComponents)!
        
        let formattedDate = date.shortFormat()
        
        XCTAssertEqual(formattedDate, "15-03-2025", "Date should be in 'dd-MM-yyyy' format")
    }
    
}
