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
        
        let property = createTestProperty()
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
        let flatProperty = createTestProperty(propertyType: "flat")
        let houseProperty = createTestProperty(propertyType: "house")
        let studioProperty = createTestProperty(propertyType: "studio")
        let unknownProperty = createTestProperty(propertyType: "unknown")
        
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
        let property = createTestProperty(exterior: true)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertEqual(
            sut.shortDescription,
            String(format: "propertyList.description".localized(), "1", "propertyList.exterior".localized()),
            "Should contain 'exterior'"
        )
    }
    
    func testInteriorPropertyDescription() throws {
        let property = createTestProperty(exterior: false)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertEqual(
            sut.shortDescription,
            String(format: "propertyList.description".localized(), "1", "propertyList.interior".localized()),
            "Should contain 'interior'"
        )
    }
    
    func testParkingSpaceIncluded() throws {
        let property = createTestProperty(hasParkingSpace: true, parkingIncluded: true)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertEqual(sut.parkingSpace,
                       "propertyList.parkingSpaceIncluded".localized(),
                       "Should contain 'parking included in price'")
    }
    
    func testParkingSpaceNotIncluded() throws {
        let property = createTestProperty(hasParkingSpace: true, parkingIncluded: false)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertEqual(sut.parkingSpace,
                       "propertyList.hasParkingSpace".localized(),
                       "Should contain 'with parking'")
    }
    
    func testNoParkingSpace() throws {
        let property = createTestProperty(hasParkingSpace: false, parkingIncluded: false)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertNil(sut.parkingSpace, "Should not have parking")
    }
    
    func testIsFavorite() throws {
        let property = createTestProperty(isFavorite: true)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertTrue(sut.isFavorite, "Should be favorite")
        XCTAssertNotNil(sut.favoriteDate, "Should have favorite date")
    }
    
    func testIsNotFavorite() throws {
        let property = createTestProperty(isFavorite: false)
        sut = PropertyCellViewModel(property: property, onFavoriteToggle: {})
        
        XCTAssertFalse(sut.isFavorite, "Should not be favorite")
        XCTAssertNil(sut.favoriteDate, "Should not have favorite date")
    }
    
    func testToggleFavorite() throws {
        sut.toggleFavorite()
        
        XCTAssertTrue(toggleFavoriteCalled, "Callback should be called")
    }
    
}

private extension PropertyCellViewModelTests {
    
    func createTestProperty(
        propertyType: String = "flat",
        exterior: Bool = true,
        isFavorite: Bool = false,
        hasParkingSpace: Bool = false,
        parkingIncluded: Bool = false
    ) -> Property {
        var property = Property(
            propertyCode: "test123",
            thumbnail: "https://example.com/test.jpg",
            floor: "1",
            price: 100000,
            priceInfo: PriceInfo(price: Price(amount: 100000, currencySuffix: "€")),
            propertyType: propertyType,
            operation: "sale",
            size: 80,
            exterior: exterior,
            rooms: 3,
            bathrooms: 2,
            address: "Test Street",
            province: "Madrid",
            municipality: "Madrid",
            district: "Centro",
            country: "ES",
            neighborhood: "Test Neighborhood",
            latitude: 40.416775,
            longitude: -3.703790,
            description: "Test description",
            multimedia: Multimedia(images: [
                PropertyImage(url: "https://example.com/img1.jpg", tag: "main"),
                PropertyImage(url: "https://example.com/img2.jpg", tag: "kitchen")
            ]),
            features: Features(
                hasSwimmingPool: false,
                hasTerrace: true,
                hasAirConditioning: true,
                hasBoxRoom: false,
                hasGarden: false
            ),
            parkingSpace: hasParkingSpace ? ParkingSpace(
                hasParkingSpace: true,
                isParkingSpaceIncludedInPrice: parkingIncluded
            ) : nil
        )
        
        property.isFavorite = isFavorite
        property.favoriteDate = isFavorite ? Date() : nil
        
        return property
    }
    
}
