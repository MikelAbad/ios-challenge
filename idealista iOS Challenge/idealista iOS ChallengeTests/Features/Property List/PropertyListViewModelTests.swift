//
//  PropertyListViewModelTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 09/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge

@MainActor
final class PropertyListViewModelTests: XCTestCase {
    
    private var sut: PropertyListViewModel!
    private var mockPropertyRepository: MockPropertyRepository!
    private var testProperties: [Property]!
    
    override func setUpWithError() throws {
        testProperties = [
            createTestProperty(code: "1", isFavorite: false),
            createTestProperty(code: "2", isFavorite: true),
            createTestProperty(code: "3", isFavorite: false)
        ]
        
        mockPropertyRepository = MockPropertyRepository()
        mockPropertyRepository.properties = testProperties
        
        sut = PropertyListViewModel(propertyRepository: mockPropertyRepository)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockPropertyRepository = nil
        testProperties = nil
    }
    
    func testInitLoadsPropertiesFromRepository() throws {
        XCTAssertEqual(sut.properties.count, 3, "Should have all three properties")
        XCTAssertEqual(sut.properties[0].propertyCode, "1", "Should be property 1")
        XCTAssertEqual(sut.properties[1].propertyCode, "2", "Should be property 2")
        XCTAssertEqual(sut.properties[2].propertyCode, "3", "Should be property 3")
    }
    
    func testSelectPropertyWhenIndexValid() throws {
        var selectedProperty: Property?
        sut.onPropertySelected = { property in
            selectedProperty = property
        }
        
        sut.selectProperty(at: 1)
        
        XCTAssertNotNil(selectedProperty, "Should have called the callback")
        XCTAssertEqual(selectedProperty?.propertyCode, "2", "Should be property 2")
        XCTAssertNotEqual(selectedProperty?.propertyCode, "3", "Should not be any other property")
    }
    
    func testSelectPropertyWhenIndexInvalid() throws {
        var callbackCalled = false
        sut.onPropertySelected = { _ in
            callbackCalled = true
        }
        
        sut.selectProperty(at: 77)
        
        XCTAssertFalse(callbackCalled, "Callback should not be called")
    }
    
    func testToggleFavoriteUpdatesProperties() throws {
        XCTAssertFalse(sut.properties[0].isFavorite, "Should not be favorite")
        
        sut.toggleFavorite(at: 0)
        
        XCTAssertTrue(mockPropertyRepository.toggleFavoriteCalled, "toggleFavoriteCalled should have been called")
        XCTAssertEqual(mockPropertyRepository.toggledPropertyCode, "1", "Should be property 1")
        XCTAssertEqual(sut.properties.count, 3, "Property count must be the same")
    }
    
    func testToggleFavoriteWithInvalidIndex() throws {
        sut.toggleFavorite(at: 77)
        
        XCTAssertFalse(mockPropertyRepository.toggleFavoriteCalled, "toggleFavorite should not have been called")
    }
    
    func testRefreshPropertiesUpdatesFromRepository() async throws {
        let newProperties = [createTestProperty(code: "4", isFavorite: true)]
        mockPropertyRepository.refreshedProperties = newProperties
        
        await sut.refreshProperties()
        
        XCTAssertTrue(mockPropertyRepository.refreshPropertiesCalled, "refreshProperties should have been called")
        XCTAssertEqual(sut.properties.count, 1, "Should have only one property")
        XCTAssertEqual(sut.properties[0].propertyCode, "4", "Should be the new property")
    }
    
    func testRefreshPropertiesError() async throws {
        mockPropertyRepository.shouldThrowError = true
        
        await sut.refreshProperties()
        
        XCTAssertTrue(mockPropertyRepository.refreshPropertiesCalled, "Should have tried to update")
        XCTAssertEqual(sut.properties.count, 3, "Should keep original properties")
    }
    
}

private extension PropertyListViewModelTests {
    
    func createTestProperty(code: String, isFavorite: Bool) -> Property {
        var property = Property(
            propertyCode: code,
            thumbnail: "https://example.com/\(code).jpg",
            floor: "1",
            price: 100000,
            priceInfo: PriceInfo(price: Price(amount: 100000, currencySuffix: "€")),
            propertyType: "flat",
            operation: "sale",
            size: 80,
            exterior: true,
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
            description: "Test description for \(code)",
            multimedia: Multimedia(images: [
                PropertyImage(url: "https://example.com/img1_\(code).jpg", tag: "main"),
                PropertyImage(url: "https://example.com/img2_\(code).jpg", tag: "kitchen")
            ]),
            features: Features(
                hasSwimmingPool: false,
                hasTerrace: true,
                hasAirConditioning: true,
                hasBoxRoom: false,
                hasGarden: false
            ),
            parkingSpace: nil
        )
        
        property.isFavorite = isFavorite
        property.favoriteDate = isFavorite ? Date() : nil
        
        return property
    }
    
}

@MainActor
private class MockPropertyRepository: PropertyRepository {
    var properties: [Property] = []
    var refreshedProperties: [Property]?
    var shouldThrowError = false
    
    var toggleFavoriteCalled = false
    var toggledPropertyCode: String?
    var refreshPropertiesCalled = false
    
    init() {
        super.init(networkService: MockNetworkService(), coreDataStack: nil)
    }
    
    override func getProperties() -> [Property] {
        properties
    }
    
    override func toggleFavorite(propertyCode: String) {
        toggleFavoriteCalled = true
        toggledPropertyCode = propertyCode
        
        if let index = properties.firstIndex(where: { $0.propertyCode == propertyCode }) {
            properties[index].isFavorite.toggle()
            properties[index].favoriteDate = properties[index].isFavorite ? Date() : nil
        }
    }
    
    override func refreshProperties() async throws {
        refreshPropertiesCalled = true
        
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 0, userInfo: nil)
        }
        
        if let refreshedProperties {
            properties = refreshedProperties
        }
    }
}

private class MockNetworkService: NetworkService {
    override func fetchData<T: Decodable>(from endpoint: String) async throws -> T {
        throw NSError(domain: "Mock", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    }
}
