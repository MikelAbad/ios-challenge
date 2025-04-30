//
//  PropertyRepository.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import Foundation

@MainActor
class PropertyRepository {
    private let networkService: NetworkService
    private var properties: [Property] = []
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchProperties() async throws {
        do {
            NetworkLogger.log(message: "Fetching properties from the API...")
            
            let properties: [Property] = try await networkService.fetchData(from: APIEndpoint.propertyList)
            self.properties = properties
            
            NetworkLogger.log(message: "Successfully loaded \(properties.count) properties", type: .success)
        } catch {
            NetworkLogger.log(message: "Network fetch failed", type: .error)
            NetworkLogger.log(message: "Falling back to offline testing data")
            try await loadLocalProperties()
        }
    }
    
    func getProperties() -> [Property] {
        properties
    }
    
}

private extension PropertyRepository {
    
    func loadLocalProperties() async throws {
        guard let url = Bundle.main.url(forResource: "list", withExtension: "json") else {
            throw NSError(domain: "PropertyRepository",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "JSON not found"])
        }
        
        do {
            let data = try Data(contentsOf: url)
            let properties = try JSONDecoder().decode([Property].self, from: data)
            self.properties = properties
            
            NetworkLogger.log(message: "Successfully loaded \(properties.count) properties from local JSON", type: .success)
        } catch {
            throw error
        }
    }
    
}
