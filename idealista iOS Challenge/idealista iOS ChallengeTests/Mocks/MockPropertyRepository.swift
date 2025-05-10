//
//  MockPropertyRepository.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 10/05/2025.
//

import Foundation
@testable import idealista_iOS_Challenge

@MainActor
class MockPropertyRepository: PropertyRepository {
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
