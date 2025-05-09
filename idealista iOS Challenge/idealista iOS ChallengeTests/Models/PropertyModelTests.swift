//
//  PropertyModelTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 09/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge

final class PropertyModelTests: XCTestCase {
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {}
    
    func testPropertyDecoding() throws {
        let jsonData = """
        {
            "propertyCode": "4",
            "thumbnail": "https://example.com/image.webp",
            "floor": "4",
            "price": 889000.0,
            "priceInfo": {
                "price": {
                    "amount": 1000.0,
                    "currencySuffix": "€/mes"
                }
            },
            "propertyType": "flat",
            "operation": "rent",
            "size": 94.0,
            "exterior": false,
            "rooms": 3,
            "bathrooms": 2,
            "address": "calle de la Povedilla",
            "province": "Madrid",
            "municipality": "Madrid",
            "district": "Barrio de Salamanca",
            "country": "es",
            "neighborhood": "Goya",
            "latitude": 40.4226243,
            "longitude": -3.6719939,
            "description": "Property description",
            "multimedia": {
                "images": [
                    {
                        "url": "https://example.com/image1.webp",
                        "tag": "livingRoom"
                    }
                ]
            },
            "features": {
                "hasSwimmingPool": false,
                "hasTerrace": false,
                "hasAirConditioning": true,
                "hasBoxRoom": false,
                "hasGarden": false
            },
            "parkingSpace": {
                "hasParkingSpace": true,
                "isParkingSpaceIncludedInPrice": false
            }
        }
        """.data(using: .utf8)!
        
        let property = try JSONDecoder().decode(Property.self, from: jsonData)
        
        XCTAssertEqual(property.propertyCode, "4", "propertyCode should match the JSON value")
        XCTAssertEqual(property.thumbnail, "https://example.com/image.webp", "thumbnail should match the JSON value")
        XCTAssertEqual(property.floor, "4", "floor should match the JSON value")
        XCTAssertEqual(property.price, 889000.0, "price should match the JSON value")
        XCTAssertEqual(property.priceInfo.price.amount, 1000.0, "amount should match the JSON value")
        XCTAssertEqual(property.priceInfo.price.currencySuffix, "€/mes", "currencySuffix should match the JSON value")
        XCTAssertEqual(property.propertyType, "flat", "propertyType should match the JSON value")
        XCTAssertEqual(property.operation, "rent", "operation should match the JSON value")
        XCTAssertEqual(property.size, 94.0, "size should match the JSON value")
        XCTAssertFalse(property.exterior, "exterior should match the JSON value")
        XCTAssertEqual(property.rooms, 3, "rooms should match the JSON value")
        XCTAssertEqual(property.bathrooms, 2, "bathrooms should match the JSON value")
        XCTAssertEqual(property.address, "calle de la Povedilla", "address should match the JSON value")
        XCTAssertEqual(property.province, "Madrid", "province should match the JSON value")
        XCTAssertEqual(property.latitude, 40.4226243, "latitude should match the JSON value")
        XCTAssertEqual(property.longitude, -3.6719939, "longitude should match the JSON value")
        
        XCTAssertEqual(property.multimedia.images.count, 1, "Should have one image")
        XCTAssertEqual(property.multimedia.images.first?.url, "https://example.com/image1.webp", "url should match the JSON value")
        XCTAssertEqual(property.multimedia.images.first?.tag, "livingRoom", "tag should match the JSON value")
        
        XCTAssertFalse(property.features.hasSwimmingPool ?? true, "hasSwimmingPool should match the JSON value")
        XCTAssertFalse(property.features.hasTerrace ?? true, "hasTerrace should match the JSON value")
        XCTAssertTrue(property.features.hasAirConditioning ?? false, "hasAirConditioning should match the JSON value")
        
        XCTAssertNotNil(property.parkingSpace, "parkingSpace should not be nil")
        XCTAssertTrue(property.parkingSpace?.hasParkingSpace ?? false, "hasParkingSpace should match the JSON value")
        XCTAssertFalse(property.parkingSpace?.isParkingSpaceIncludedInPrice ?? true, "isParkingSpaceIncludedInPrice should match the JSON value")
        
        XCTAssertFalse(property.isFavorite, "isFavorite should not be favorite by default")
        XCTAssertNil(property.favoriteDate, "favoriteDate date should be nil by default")
    }
    
    func testPropertyWithoutOptionalFields() throws {
        let jsonData = """
        {
            "propertyCode": "4",
            "thumbnail": "https://example.com/image.webp",
            "floor": "4",
            "price": 889000.0,
            "priceInfo": {
                "price": {
                    "amount": 1000.0,
                    "currencySuffix": "€/mes"
                }
            },
            "propertyType": "flat",
            "operation": "rent",
            "size": 94.0,
            "exterior": false,
            "rooms": 3,
            "bathrooms": 2,
            "address": "calle de la Povedilla",
            "province": "Madrid",
            "municipality": "Madrid",
            "district": "Barrio de Salamanca",
            "country": "es",
            "neighborhood": "Goya",
            "latitude": 40.4226243,
            "longitude": -3.6719939,
            "description": "Property description",
            "multimedia": {
                "images": []
            },
            "features": {
                "hasSwimmingPool": null,
                "hasTerrace": null,
                "hasAirConditioning": null,
                "hasBoxRoom": null,
                "hasGarden": null
            }
        }
        """.data(using: .utf8)!
        
        let property = try JSONDecoder().decode(Property.self, from: jsonData)
        
        XCTAssertEqual(property.propertyCode, "4", "propertyCode should match the JSON value")
        XCTAssertNil(property.parkingSpace, "parkingSpace should be nil when not provided in JSON")
        XCTAssertNil(property.features.hasSwimmingPool, "hasSwimmingPool should be nil when null in JSON")
        XCTAssertNil(property.features.hasTerrace, "hasTerrace should be nil when null in JSON")
        XCTAssertEqual(property.multimedia.images.count, 0, "Should have no images")
    }
}
