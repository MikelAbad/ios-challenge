//
//  MockPropertyDetailsRepository.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 10/05/2025.
//

import Foundation
@testable import idealista_iOS_Challenge

@MainActor
class MockPropertyDetailsRepository: PropertyDetailsRepository {
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
