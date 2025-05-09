//
//  AlertHelperTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 09/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge

final class AlertHelperTests: XCTestCase {
    
    private var mockViewController: MockViewController!
    
    override func setUpWithError() throws {
        mockViewController = MockViewController()
    }
    
    override func tearDownWithError() throws {
        mockViewController = nil
    }
    
    func testShowAlert() throws {
        let title = "Test Title"
        let message = "Test Message"
        
        AlertHelper.showAlert(
            title: title,
            message: message,
            on: mockViewController
        )
        
        XCTAssertTrue(mockViewController.presentMethodCalled, "Present method should have been called")
        
        if let alertController = mockViewController.presentedViewController as? UIAlertController {
            XCTAssertEqual(alertController.preferredStyle, .alert, "Alert style should be '.alert'")
            XCTAssertEqual(alertController.title, title, "Alert title should be the same")
            XCTAssertEqual(alertController.message, message, "Alert message should be the same")
            
            XCTAssertEqual(alertController.actions.count, 1, "It must have a button")
            XCTAssertEqual(alertController.actions.first?.title, "alert.ok".localized(), "The button should be labeled 'OK'")
        } else {
            XCTFail("An UIAlertController should have been presented")
        }
    }
    
    func testShowOfflineAlert() throws {
        AlertHelper.showOfflineAlert(on: mockViewController, completion: { print("Completion called") })
        
        XCTAssertTrue(mockViewController.presentMethodCalled, "Present method should have been called")
        
        if let alertController = mockViewController.presentedViewController as? UIAlertController {
            XCTAssertEqual(alertController.title, "alert.warning".localized(), "Alert title should be 'Warning'")
            XCTAssertEqual(alertController.message, "alert.offline.message".localized(), "Alert message should be about being offline")
            
            XCTAssertEqual(alertController.actions.count, 1, "It must have a button")
            XCTAssertEqual(alertController.actions.first?.title, "alert.ok".localized(), "The button should be labeled 'OK'")
        } else {
            XCTFail("An UIAlertController should have been presented")
        }
    }
    
    func testShowCriticalErrorAlert() throws {
        AlertHelper.showCriticalErrorAlert(on: mockViewController)
        
        XCTAssertTrue(mockViewController.presentMethodCalled, "Present method should have been called")
        
        if let alertController = mockViewController.presentedViewController as? UIAlertController {
            XCTAssertEqual(alertController.preferredStyle, .actionSheet, "Alert style should be .actionSheet")
            
            XCTAssertEqual(alertController.title, "alert.error".localized(), "Alert title should be 'Error'")
            XCTAssertEqual(alertController.message, "alert.error.message".localized(), "Alert message should be about critical error")
            
            XCTAssertEqual(alertController.actions.count, 0, "Alert should not have any button")
        } else {
            XCTFail("An UIAlertController should have been presented")
        }
    }
    
}

private class MockViewController: UIViewController {
    private var _mockedPresentedViewController: UIViewController?
    var presentMethodCalled = false
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentMethodCalled = true
        _mockedPresentedViewController = viewControllerToPresent
        completion?()
    }
    
    override var presentedViewController: UIViewController? {
        _mockedPresentedViewController
    }
}
