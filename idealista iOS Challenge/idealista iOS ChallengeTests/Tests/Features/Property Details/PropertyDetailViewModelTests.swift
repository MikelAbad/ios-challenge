//
//  PropertyDetailViewModelTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 09/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge

@MainActor
final class PropertyDetailViewModelTests: XCTestCase {
    
    private var sut: PropertyDetailViewModel!
    private var mockRepository: MockPropertyDetailsRepository!
    
    private var testProperty: Property!
    private var testPropertyDetails: PropertyDetails!
    
    override func setUpWithError() throws {
        testProperty = TestDataFactory.createProperty(isFavorite: true)
        testPropertyDetails = TestDataFactory.createPropertyDetails()
        
        mockRepository = MockPropertyDetailsRepository()
        mockRepository.propertyDetails = testPropertyDetails
        
        sut = PropertyDetailViewModel(property: testProperty, repository: mockRepository)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
        testProperty = nil
        testPropertyDetails = nil
    }
    
    func testInitPropertiesCorrectlySet() throws {
        XCTAssertEqual(sut.propertyCode, "4", "Should be '4'")
        XCTAssertTrue(sut.isFavorite, "Should be favorite")
    }
    
    func testTitleUsesCorrectLocalizationFormat() throws {
        let expectedTitle = String(format: "propertyDetail.propertyIn".localized(),
                                   PropertyType(from: "flat").name,
                                   "Test Street")
        
        XCTAssertEqual(sut.title, expectedTitle, "Should use correct format")
    }
    
    func testSubtitleUsesCorrectLocalizationFormat() throws {
        let expectedSubtitle = String(format: "propertyDetail.address".localized(),
                                      "Test Neighborhood",
                                      "Centro",
                                      "Madrid"
        )
        
        XCTAssertEqual(sut.subtitle, expectedSubtitle, "Should use correct format")
    }
    
    func testShortPropertyDescriptionForFlatExteriorUsesCorrectFormat() throws {
        let expectedDescription = String(format: "propertyDetail.description".localized(),
                                         "1",
                                         "propertyDetail.exterior".localized())
        
        XCTAssertEqual(sut.shortPropertyDescription, expectedDescription, "Should use correct format")
    }
    
    func testShortPropertyDescriptionForFlatInteriorUsesCorrectFormat() throws {
        testProperty = TestDataFactory.createProperty(exterior: false)
        sut = PropertyDetailViewModel(property: testProperty, repository: mockRepository)
        
        let expectedDescription = String(format: "propertyDetail.description".localized(),
                                         "1",
                                         "propertyDetail.interior".localized())
        
        XCTAssertEqual(sut.shortPropertyDescription, expectedDescription,
                       "Should use correct format")
    }
    
    func testParkingSpaceWithParkingIncludedUsesCorrectFormat() throws {
        testProperty = TestDataFactory.createProperty(hasParkingSpace: true, parkingIncluded: true)
        sut = PropertyDetailViewModel(property: testProperty, repository: mockRepository)
        
        let expectedText = "propertyDetail.parkingSpaceIncluded".localized()
        
        XCTAssertEqual(sut.parkingSpace, expectedText, "Should use correct format")
    }
    
    func testParkingSpaceWithParkingNotIncludedUsesCorrectFormat() throws {
        testProperty = TestDataFactory.createProperty(hasParkingSpace: true, parkingIncluded: false)
        sut = PropertyDetailViewModel(property: testProperty, repository: mockRepository)
        
        let expectedText = "propertyDetail.hasParkingSpace".localized()
        
        XCTAssertEqual(sut.parkingSpace, expectedText, "Should use correct format")
    }
    
    func testParkingSpaceWithoutParkingReturnsNil() throws {
        testProperty = TestDataFactory.createProperty(hasParkingSpace: false, parkingIncluded: false)
        sut = PropertyDetailViewModel(property: testProperty, repository: mockRepository)
        
        XCTAssertNil(sut.parkingSpace, "Should not have parking")
    }
    
    func testBasicFeaturesContainsCorrectItems() throws {
        sut.propertyDetails = testPropertyDetails
        
        let features = sut.basicFeatures
        
        XCTAssertTrue(features.contains("80 m²"), "Should contain size")
        
        let roomsLocalized = "propertyDetail.rooms".localized()
        XCTAssertTrue(features.contains("3 \(roomsLocalized)"), "Should contain rooms")
        
        let bathroomsLocalized = "propertyDetail.bathrooms".localized()
        XCTAssertTrue(features.contains("2 \(bathroomsLocalized)"), "Should contain bathrooms")
        
        let boxroomLocalized = "propertyDetail.boxroom".localized()
        XCTAssertTrue(features.contains(boxroomLocalized), "Should contain boxroom")
        
        let airConditioningLocalized = "propertyDetail.airConditioning".localized()
        XCTAssertTrue(features.contains(airConditioningLocalized), "Should contain air conditioning")
        
        let communityLocalized = "propertyDetail.community".localized()
        XCTAssertTrue(features.contains { $0.contains(communityLocalized) }, "Should contain community costs")
    }
    
    func testBuildingFeaturesWithElevatorContainsCorrectItems() throws {
        testPropertyDetails = TestDataFactory.createPropertyDetails(hasElevator: true)
        sut.propertyDetails = testPropertyDetails
        
        let features = sut.buildingFeatures
        
        XCTAssertTrue(features.contains(sut.shortPropertyDescription), "Should contain short description")
        
        XCTAssertTrue(features.contains("propertyDetail.hasElevator".localized()), "Should contain elevator")
    }
    
    func testBuildingFeaturesWithoutElevatorContainsCorrectItems() throws {
        testPropertyDetails = TestDataFactory.createPropertyDetails(hasElevator: false)
        sut.propertyDetails = testPropertyDetails
        
        let features = sut.buildingFeatures
        
        XCTAssertTrue(features.contains(sut.shortPropertyDescription), "Should contain short description")
        
        XCTAssertTrue(features.contains("propertyDetail.noElevator".localized()), "Should not contain elevator")
    }
    
    func testEnergyCertificationItemsUsesCorrectLocalizationFormat() throws {
        sut.propertyDetails = testPropertyDetails
        
        let items = sut.energyCertificationItems
        
        let consumptionKey = "propertyDetail.energyConsumption".localized()
        XCTAssertTrue(items[0].contains(consumptionKey), "Should use correct format")
        
        let emissionsKey = "propertyDetail.energyEmission".localized()
        XCTAssertTrue(items[1].contains(emissionsKey), "Should use correct format")
    }
    
    func testLoadPropertyDetailsSuccessUpdatesViewModel() async throws {
        await sut.loadPropertyDetails()
        
        XCTAssertNotNil(sut.propertyDetails, "Should load details")
        XCTAssertEqual(sut.imagesCount, testPropertyDetails.multimedia.images.count, "Should have images")
    }
    
    func testLoadPropertyDetailsErrorDoesNotUpdateViewModel() async throws {
        mockRepository.shouldThrowError = true
        
        await sut.loadPropertyDetails()
        
        XCTAssertNil(sut.propertyDetails, "Should not load details")
        XCTAssertEqual(sut.imagesCount, 0, "Should have no images")
    }
    
    func testImageURLValidIndexReturnsCorrectURL() throws {
        sut.propertyDetails = testPropertyDetails
        
        XCTAssertEqual(sut.imageURL(at: 0)?.absoluteString,
                       "https://example.com/detail1.jpg",
                       "Should return correct URL for index 0")
        XCTAssertEqual(sut.imageURL(at: 1)?.absoluteString,
                       "https://example.com/detail2.jpg",
                       "Should return correct URL for index 1")
    }
    
    func testImageURLInvalidIndexReturnsNil() throws {
        sut.propertyDetails = testPropertyDetails
        
        XCTAssertNil(sut.imageURL(at: 999), "Should return nil for invalid index")
    }
    
}
