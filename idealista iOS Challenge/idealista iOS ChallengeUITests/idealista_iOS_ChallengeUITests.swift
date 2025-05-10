//
//  idealista_iOS_ChallengeUITests.swift
//  idealista iOS ChallengeUITests
//
//  Created by Mikel Abad on 29/04/2025.
//

import XCTest

final class idealista_iOS_ChallengeUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = [TestingLaunchArguments.uiTesting]
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Splash Screen Tests
    
    func testSplashScreenElements() throws {
        app.launch()
        
        let logo = app.images[AccessibilityIdentifiers.SplashScreen.logoImage]
        XCTAssertTrue(logo.exists, "App logo should be visible")
        
        let activityIndicator = app.activityIndicators[AccessibilityIdentifiers.SplashScreen.activityIndicator]
        XCTAssertTrue(activityIndicator.exists, "Activity indicator should be visible")
        
        let propertyListTable = app.tables[AccessibilityIdentifiers.PropertyList.tableView]
        XCTAssertTrue(propertyListTable.waitForExistence(timeout: 5), "Should navigate to Property List")
    }
    
    // MARK: - Property List Tests
    
    func testPropertyListElements() throws {
        app.launch()
        
        let propertyListTable = app.tables[AccessibilityIdentifiers.PropertyList.tableView]
        XCTAssertTrue(propertyListTable.waitForExistence(timeout: 10), "Property list table should appear")
        
        let cells = propertyListTable.cells
        XCTAssertGreaterThan(cells.count, 0, "Property list should have at least one cell")
        
        let firstCell = cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2), "First cell should exist")
        
        XCTAssertTrue(firstCell.staticTexts[AccessibilityIdentifiers.PropertyList.titleLabel].exists,
                      "Property title should exist in cell")
        XCTAssertTrue(firstCell.staticTexts[AccessibilityIdentifiers.PropertyList.priceLabel].exists,
                      "Property price should exist in cell")
        XCTAssertTrue(firstCell.buttons[AccessibilityIdentifiers.PropertyList.favoriteButton].exists,
                      "Favorite button should exist in cell")
        XCTAssertTrue(firstCell.staticTexts[AccessibilityIdentifiers.PropertyList.roomsLabel].exists,
                      "Rooms label should exist in cell")
        XCTAssertTrue(firstCell.staticTexts[AccessibilityIdentifiers.PropertyList.bathroomsLabel].exists,
                      "Bathrooms label should exist in cell")
        XCTAssertTrue(firstCell.staticTexts[AccessibilityIdentifiers.PropertyList.sizeLabel].exists,
                      "Size label should exist in cell")
        XCTAssertTrue(firstCell.staticTexts[AccessibilityIdentifiers.PropertyList.descriptionLabel].exists,
                      "Description label should exist in cell")
    }
    
    func testPropertyListNavigation() throws {
        app.launch()
        
        let propertyListTable = app.tables[AccessibilityIdentifiers.PropertyList.tableView]
        XCTAssertTrue(propertyListTable.waitForExistence(timeout: 10), "Property list table should appear")
        
        let firstCell = propertyListTable.cells.element(boundBy: 0)
        let titleLabel = firstCell.staticTexts[AccessibilityIdentifiers.PropertyList.titleLabel]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 2), "Title label should exist")
        titleLabel.tap()
        
        let detailView = app.otherElements[AccessibilityIdentifiers.PropertyDetail.mainView]
        XCTAssertTrue(detailView.waitForExistence(timeout: 10), "Property detail view should appear")
    }
    
    // MARK: - Property Detail Tests
    
    func testPropertyDetailElements() throws {
        app.launch()
        
        let propertyListTable = app.tables[AccessibilityIdentifiers.PropertyList.tableView]
        XCTAssertTrue(propertyListTable.waitForExistence(timeout: 10), "Property list table should appear")
        
        let firstCell = propertyListTable.cells.element(boundBy: 0)
        let titleLabel = firstCell.staticTexts[AccessibilityIdentifiers.PropertyList.titleLabel]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 2), "Title label should exist")
        titleLabel.tap()
        
        let detailView = app.otherElements[AccessibilityIdentifiers.PropertyDetail.mainView]
        XCTAssertTrue(detailView.waitForExistence(timeout: 5), "Property detail view should appear")
        
        let imagesCollection = app.collectionViews[AccessibilityIdentifiers.PropertyDetail.imagesCollection]
        XCTAssertTrue(imagesCollection.exists, "Images collection should exist in detail view")
        
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.titleLabel].exists, "Property title should exist in detail view")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.subtitleLabel].exists, "Property subtitle should exist in detail view")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.priceLabel].exists, "Property price should exist in detail view")
        
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.roomsLabel].exists, "Property rooms should exist in detail view")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.bathroomsLabel].exists, "Property bathrooms should exist in detail view")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.sizeLabel].exists, "Property size should exist in detail view")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.shortDescriptionLabel].exists, "Property desc should exist in detail view")
        
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.basicFeaturesTitle].exists, "Basic features title should exist")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.buildingFeaturesTitle].exists, "Building features title should exist")
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.energyCertificationTitle].exists, "Energy certification title should exist")
        
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.PropertyDetail.mapTitle].exists, "Map title should exist in detail view")
        XCTAssertTrue(app.otherElements[AccessibilityIdentifiers.PropertyDetail.mapView].exists, "Map view should exist in detail view")
    }
    
    func testPropertyDetailDescriptionExpand() throws {
        app.launch()
        
        let propertyListTable = app.tables[AccessibilityIdentifiers.PropertyList.tableView]
        XCTAssertTrue(propertyListTable.waitForExistence(timeout: 10), "Property list table should appear")
        
        let firstCell = propertyListTable.cells.element(boundBy: 0)
        let titleLabel = firstCell.staticTexts[AccessibilityIdentifiers.PropertyList.titleLabel]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 2), "Title label should exist")
        titleLabel.tap()
        
        let showMoreButton = app.buttons[AccessibilityIdentifiers.PropertyDetail.showMoreButton]
        
        if showMoreButton.exists {
            let descriptionLabel = app.staticTexts[AccessibilityIdentifiers.PropertyDetail.descriptionLabel]
            let initialDescription = descriptionLabel.label
            
            showMoreButton.tap()
            
            XCTAssertNotEqual(descriptionLabel.label, initialDescription, "Description should be expanded")

            showMoreButton.tap()
            
            XCTAssertEqual(descriptionLabel.label, initialDescription, "Description should be collapses")
        }
    }
    
    func testImagesNavigation() throws {
        app.launch()
        
        let propertyListTable = app.tables[AccessibilityIdentifiers.PropertyList.tableView]
        XCTAssertTrue(propertyListTable.waitForExistence(timeout: 10), "Property list table should appear")
        
        let firstCell = propertyListTable.cells.element(boundBy: 0)
        let titleLabel = firstCell.staticTexts[AccessibilityIdentifiers.PropertyList.titleLabel]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 2), "Title label should exist")
        titleLabel.tap()
        
        let imagesCollection = app.collectionViews[AccessibilityIdentifiers.PropertyDetail.imagesCollection]
        XCTAssertTrue(imagesCollection.waitForExistence(timeout: 5), "Images collection should exist")
        
        imagesCollection.swipeLeft()
        
        let pageIndicator = app.staticTexts[AccessibilityIdentifiers.PropertyDetail.pageIndicator]
        XCTAssertTrue(pageIndicator.label.contains("2"), "Page indicator should update")
    }
}
