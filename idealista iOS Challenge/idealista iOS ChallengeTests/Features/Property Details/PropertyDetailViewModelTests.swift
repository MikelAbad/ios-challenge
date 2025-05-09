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
        testProperty = createTestProperty()
        testPropertyDetails = createTestPropertyDetails()
        
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
        testProperty = createTestProperty(exterior: false)
        sut = PropertyDetailViewModel(property: testProperty, repository: mockRepository)
        
        let expectedDescription = String(format: "propertyDetail.description".localized(),
                                         "1",
                                         "propertyDetail.interior".localized())
        
        XCTAssertEqual(sut.shortPropertyDescription, expectedDescription,
                       "Should use correct format")
    }
    
    func testParkingSpaceWithParkingIncludedUsesCorrectFormat() throws {
        testProperty = createTestProperty(hasParkingSpace: true, parkingIncluded: true)
        sut = PropertyDetailViewModel(property: testProperty, repository: mockRepository)
        
        let expectedText = "propertyDetail.parkingSpaceIncluded".localized()
        
        XCTAssertEqual(sut.parkingSpace, expectedText, "Should use correct format")
    }
    
    func testParkingSpaceWithParkingNotIncludedUsesCorrectFormat() throws {
        testProperty = createTestProperty(hasParkingSpace: true, parkingIncluded: false)
        sut = PropertyDetailViewModel(property: testProperty, repository: mockRepository)
        
        let expectedText = "propertyDetail.hasParkingSpace".localized()
        
        XCTAssertEqual(sut.parkingSpace, expectedText, "Should use correct format")
    }
    
    func testParkingSpaceWithoutParkingReturnsNil() throws {
        testProperty = createTestProperty(hasParkingSpace: false)
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
        testPropertyDetails = createTestPropertyDetails(hasElevator: true)
        sut.propertyDetails = testPropertyDetails
        
        let features = sut.buildingFeatures
        
        XCTAssertTrue(features.contains(sut.shortPropertyDescription), "Should contain short description")
        
        XCTAssertTrue(features.contains("propertyDetail.hasElevator".localized()), "Should contain elevator")
    }
    
    func testBuildingFeaturesWithoutElevatorContainsCorrectItems() throws {
        testPropertyDetails = createTestPropertyDetails(hasElevator: false)
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

private extension PropertyDetailViewModelTests {
    
    func createTestProperty(
        exterior: Bool = true,
        isFavorite: Bool = true,
        hasParkingSpace: Bool = false,
        parkingIncluded: Bool = false
    ) -> Property {
        var property = Property(
            propertyCode: "4",
            thumbnail: "https://example.com/test.jpg",
            floor: "1",
            price: 100000,
            priceInfo: PriceInfo(price: Price(amount: 100000, currencySuffix: "€")),
            propertyType: "flat",
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
                hasBoxRoom: true,
                hasGarden: false
            ),
            parkingSpace: hasParkingSpace ? ParkingSpace(
                hasParkingSpace: true,
                isParkingSpaceIncludedInPrice: parkingIncluded
            ) : nil
        )
        
        property.isFavorite = isFavorite
        
        return property
    }
    
    func createTestPropertyDetails(
        hasElevator: Bool = true
    ) -> PropertyDetails {
        return PropertyDetails(
            adid: 1,
            price: 100000,
            priceInfo: DetailPriceInfo(amount: 100000, currencySuffix: "€"),
            operation: "sale",
            propertyType: "flat",
            extendedPropertyType: "flat",
            homeType: "home",
            state: "good",
            multimedia: DetailMultimedia(images: [
                DetailPropertyImage(url: "https://example.com/detail1.jpg", tag: "main", localizedName: "Main", multimediaId: 1),
                DetailPropertyImage(url: "https://example.com/detail2.jpg", tag: "kitchen", localizedName: "Kitchen", multimediaId: 2),
                DetailPropertyImage(url: "https://example.com/detail3.jpg", tag: "bathroom", localizedName: "Bathroom", multimediaId: 3)
            ]),
            propertyComment: "This is a detailed property description with more than 200 characters. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent euismod, nisi vel consectetur euismod, nisl nisi consectetur nisl, eget consectetur nisl nisi vel nisl. Praesent euismod, nisi vel consectetur euismod, nisl nisi consectetur nisl, eget consectetur nisl nisi vel nisl.",
            ubication: Ubication(latitude: 40.416775, longitude: -3.703790),
            country: "ES",
            moreCharacteristics: MoreCharacteristics(
                communityCosts: 50,
                roomNumber: 3,
                bathNumber: 2,
                exterior: true,
                housingFurnitures: "",
                agencyIsABank: false,
                energyCertificationType: "E",
                flatLocation: "street",
                modificationDate: 0,
                constructedArea: 80,
                lift: hasElevator,
                boxroom: true,
                isDuplex: false,
                floor: "1",
                status: "good"
            ),
            energyCertification: EnergyCertification(
                title: "Energy Certificate",
                energyConsumption: EnergyLevel(type: "E"),
                emissions: EnergyLevel(type: "F")
            )
        )
    }
    
}

@MainActor
private class MockPropertyDetailsRepository: PropertyDetailsRepository {
    var propertyDetails: PropertyDetails?
    var shouldThrowError = false
    
    init() {
        super.init(networkService: MockNetworkService())
    }
    
    override func fetchPropertyDetails(propertyCode: String) async throws -> PropertyDetails {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        }
        
        guard let details = propertyDetails else {
            throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No details available"])
        }
        
        return details
    }
}

private class MockNetworkService: NetworkService {
    override func fetchData<T: Decodable>(from endpoint: String) async throws -> T {
        throw NSError(domain: "Mock", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    }
}
