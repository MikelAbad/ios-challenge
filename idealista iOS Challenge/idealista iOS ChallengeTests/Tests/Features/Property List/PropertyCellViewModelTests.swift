//
//  PropertyCellViewModelTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 09/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge

final class PropertyCellViewModelTests: XCTestCase {
    
    private var sut: PropertyCellViewModel!
    private var toggleFavoriteCalled = false
    
    override func setUpWithError() throws {
        toggleFavoriteCalled = false
        
        let property = TestDataFactory.createProperty()
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: { [weak self] in
            guard let self else { return }
            toggleFavoriteCalled = true
        })
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testTitleUsesCorrectFormat() throws {
        let titleFormat = String(format: "propertyList.propertyIn".localized(), "propertyList.flat".localized(), "Test Street")
        
        XCTAssertEqual(sut.title, titleFormat, "Title should match")
    }
    
    func testTitleContainsCorrectPropertyType() throws {
        let flatProperty = TestDataFactory.createProperty(propertyType: "flat")
        let houseProperty = TestDataFactory.createProperty(propertyType: "house")
        let studioProperty = TestDataFactory.createProperty(propertyType: "studio")
        let unknownProperty = TestDataFactory.createProperty(propertyType: "unknown")
        
        let flatViewModel = PropertyCellViewModel(property: flatProperty, onFavoriteToggle: {})
        let houseViewModel = PropertyCellViewModel(property: houseProperty, onFavoriteToggle: {})
        let studioViewModel = PropertyCellViewModel(property: studioProperty, onFavoriteToggle: {})
        let unknownViewModel = PropertyCellViewModel(property: unknownProperty, onFavoriteToggle: {})
        
        XCTAssertTrue(flatViewModel.title.contains("propertyList.flat".localized()), "Should contain 'flat'")
        XCTAssertTrue(houseViewModel.title.contains("propertyList.house".localized()), "Should contain 'house'")
        XCTAssertTrue(studioViewModel.title.contains("propertyList.studio".localized()), "Should contain 'studio'")
        XCTAssertTrue(unknownViewModel.title.contains("propertyList.property".localized()), "Should contain 'property'")
    }
    
    func testFormatsPrice() throws {
        XCTAssertEqual(sut.price, "100000", "Price should match")
        XCTAssertEqual(sut.currencySuffix, "€", "Suffix should match")
    }
    
    func testFormatsRoomsAndBathrooms() throws {
        XCTAssertEqual(sut.rooms, "3", "Rooms should match")
        XCTAssertEqual(sut.bathrooms, "2", "Bathrooms should match")
    }
    
    func testFormatsSize() throws {
        XCTAssertEqual(sut.size, "80 m²", "Size should match")
    }
    
    func testExteriorPropertyDescription() throws {
        let property = TestDataFactory.createProperty(exterior: true)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertEqual(
            sut.shortDescription,
            String(format: "propertyList.description".localized(), "1", "propertyList.exterior".localized()),
            "Should contain 'exterior'"
        )
    }
    
    func testInteriorPropertyDescription() throws {
        let property = TestDataFactory.createProperty(exterior: false)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertEqual(
            sut.shortDescription,
            String(format: "propertyList.description".localized(), "1", "propertyList.interior".localized()),
            "Should contain 'interior'"
        )
    }
    
    func testParkingSpaceIncluded() throws {
        let property = TestDataFactory.createProperty(hasParkingSpace: true, parkingIncluded: true)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertEqual(sut.parkingSpace,
                       "propertyList.parkingSpaceIncluded".localized(),
                       "Should contain 'parking included in price'")
    }
    
    func testParkingSpaceNotIncluded() throws {
        let property = TestDataFactory.createProperty(hasParkingSpace: true, parkingIncluded: false)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertEqual(sut.parkingSpace,
                       "propertyList.hasParkingSpace".localized(),
                       "Should contain 'with parking'")
    }
    
    func testNoParkingSpace() throws {
        let property = TestDataFactory.createProperty(hasParkingSpace: false, parkingIncluded: false)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertNil(sut.parkingSpace, "Should not have parking")
    }
    
    func testIsFavorite() throws {
        let property = TestDataFactory.createProperty(isFavorite: true)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertTrue(sut.isFavorite, "Should be favorite")
        XCTAssertNotNil(sut.favoriteDate, "Should have favorite date")
    }
    
    func testIsNotFavorite() throws {
        let property = TestDataFactory.createProperty(isFavorite: false)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertFalse(sut.isFavorite, "Should not be favorite")
        XCTAssertNil(sut.favoriteDate, "Should not have favorite date")
    }
    
    func testToggleFavorite() throws {
        sut.toggleFavorite()
        
        XCTAssertTrue(toggleFavoriteCalled, "Callback should be called")
    }
    
}
