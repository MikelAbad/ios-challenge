//
//  PropertyDetailsRepository.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 06/05/2025.
//

import Foundation

@MainActor
class PropertyDetailsRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchPropertyDetails(propertyCode: String) async throws -> PropertyDetails {
        do {
            NetworkLogger.log(message: "Fetching property details from the API...")
            
            let detailsURL = String(format: APIEndpoint.propertyDetail, propertyCode)
            let details: PropertyDetails = try await networkService.fetchData(from: detailsURL)
            
            NetworkLogger.log(message: "Successfully loaded property details!", type: .success)
            
            return details
        } catch {
            NetworkLogger.log(message: "Network fetch failed", type: .error)
            NetworkLogger.log(message: "Falling back to offline testing data")
            
            return try await loadLocalPropertyDetails(propertyCode: propertyCode)
        }
    }
}

private extension PropertyDetailsRepository {
    
    func loadLocalPropertyDetails(propertyCode: String) async throws -> PropertyDetails {
        guard let url = Bundle.main.url(forResource: "detail_\(propertyCode)", withExtension: "json") else {
            throw NSError(domain: "PropertyDetailsRepository",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "JSON not found"])
        }
        
        let data = try Data(contentsOf: url)
        let details = try JSONDecoder().decode(PropertyDetails.self, from: data)
        
        NetworkLogger.log(message: "Successfully loaded property details from local JSON!", type: .success)
        
        return details
    }
    
}
