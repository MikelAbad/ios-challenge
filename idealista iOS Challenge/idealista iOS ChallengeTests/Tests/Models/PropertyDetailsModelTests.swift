//
//  PropertyDetailsModelTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 09/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge

final class PropertyDetailsModelTests: XCTestCase {
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {}
    
    func testPropertyDetailsDecoding() throws {
        let jsonData = """
        {
          "adid": 1,
          "price": 1195000.0,
          "priceInfo": {
            "amount": 1195000.0,
            "currencySuffix": "€"
          },
          "operation": "sale",
          "propertyType": "homes",
          "extendedPropertyType": "flat",
          "homeType": "flat",
          "state": "active",
          "multimedia": {
            "images": [
              {
                "url": "https://example.com/image1.webp",
                "tag": "livingRoom",
                "localizedName": "Salón",
                "multimediaId": 12345
              }
            ]
          },
          "propertyComment": "Property description",
          "ubication": {
            "latitude": 40.4362687,
            "longitude": -3.6833686
          },
          "country": "es",
          "moreCharacteristics": {
            "communityCosts": 330.0,
            "roomNumber": 3,
            "bathNumber": 2,
            "exterior": false,
            "housingFurnitures": "unknown",
            "agencyIsABank": false,
            "energyCertificationType": "e",
            "flatLocation": "internal",
            "modificationDate": 1727683968000,
            "constructedArea": 133,
            "lift": true,
            "boxroom": false,
            "isDuplex": false,
            "floor": "2",
            "status": "renew"
          },
          "energyCertification": {
            "title": "Certificado energético",
            "energyConsumption": {
              "type": "e"
            },
            "emissions": {
              "type": "e"
            }
          }
        }
        """.data(using: .utf8)!
        
        let propertyDetails = try JSONDecoder().decode(PropertyDetails.self, from: jsonData)
        
        XCTAssertEqual(propertyDetails.adid, 1, "adid should match the JSON value")
        XCTAssertEqual(propertyDetails.price, 1195000.0, "price should match the JSON value")
        XCTAssertEqual(propertyDetails.priceInfo.amount, 1195000.0, "amount should match the JSON value")
        XCTAssertEqual(propertyDetails.priceInfo.currencySuffix, "€", "currencySuffix should match the JSON value")
        XCTAssertEqual(propertyDetails.operation, "sale", "operation should match the JSON value")
        XCTAssertEqual(propertyDetails.propertyType, "homes", "propertyType should match the JSON value")
        XCTAssertEqual(propertyDetails.extendedPropertyType, "flat", "extendedPropertyType should match the JSON value")
        XCTAssertEqual(propertyDetails.homeType, "flat", "homeType should match the JSON value")
        XCTAssertEqual(propertyDetails.state, "active", "state should match the JSON value")
        
        XCTAssertEqual(propertyDetails.multimedia.images.count, 1, "Should have one image")
        XCTAssertEqual(propertyDetails.multimedia.images.first?.url, "https://example.com/image1.webp", "url should match the JSON value")
        XCTAssertEqual(propertyDetails.multimedia.images.first?.tag, "livingRoom", "tag should match the JSON value")
        XCTAssertEqual(propertyDetails.multimedia.images.first?.localizedName, "Salón", "localizedName name should match the JSON value")
        XCTAssertEqual(propertyDetails.multimedia.images.first?.multimediaId, 12345, "multimediaId should match the JSON value")
        
        XCTAssertEqual(propertyDetails.propertyComment, "Property description", "propertyComment should match the JSON value")
        
        XCTAssertEqual(propertyDetails.ubication.latitude, 40.4362687, "latitude should match the JSON value")
        XCTAssertEqual(propertyDetails.ubication.longitude, -3.6833686, "longitude should match the JSON value")
        
        XCTAssertEqual(propertyDetails.country, "es", "country should match the JSON value")
        
        XCTAssertEqual(propertyDetails.moreCharacteristics.communityCosts, 330.0, "communityCosts should match the JSON value")
        XCTAssertEqual(propertyDetails.moreCharacteristics.roomNumber, 3, "roomNumber should match the JSON value")
        XCTAssertEqual(propertyDetails.moreCharacteristics.bathNumber, 2, "bathNumber should match the JSON value")
        XCTAssertFalse(propertyDetails.moreCharacteristics.exterior, "exterior should match the JSON value")
        XCTAssertEqual(propertyDetails.moreCharacteristics.housingFurnitures, "unknown", "housingFurnitures should match the JSON value")
        XCTAssertFalse(propertyDetails.moreCharacteristics.agencyIsABank, "agencyIsABank should match the JSON value")
        XCTAssertEqual(propertyDetails.moreCharacteristics.energyCertificationType, "e", "energyCertificationType should match the JSON value")
        XCTAssertEqual(propertyDetails.moreCharacteristics.flatLocation, "internal", "flatLocation should match the JSON value")
        XCTAssertEqual(propertyDetails.moreCharacteristics.modificationDate, 1727683968000, "modificationDate should match the JSON value")
        XCTAssertEqual(propertyDetails.moreCharacteristics.constructedArea, 133, "constructedArea should match the JSON value")
        XCTAssertTrue(propertyDetails.moreCharacteristics.lift, "lift should match the JSON value")
        XCTAssertFalse(propertyDetails.moreCharacteristics.boxroom, "boxroom should match the JSON value")
        XCTAssertFalse(propertyDetails.moreCharacteristics.isDuplex, "isDuplex should match the JSON value")
        XCTAssertEqual(propertyDetails.moreCharacteristics.floor, "2", "floor should match the JSON value")
        XCTAssertEqual(propertyDetails.moreCharacteristics.status, "renew", "status should match the JSON value")
        
        XCTAssertEqual(propertyDetails.energyCertification.title, "Certificado energético", "title should match the JSON value")
        XCTAssertEqual(propertyDetails.energyCertification.energyConsumption.type, "e", "type should match the JSON value")
        XCTAssertEqual(propertyDetails.energyCertification.emissions.type, "e", "type should match the JSON value")
    }
    
}
