//
//  PropertyRepository.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import Foundation

enum DataLoadingResult {
    case online
    case offline
    case error(Error)
}

@MainActor
class PropertyRepository {
    private let networkService: NetworkService
    private var properties: [Property] = []
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchProperties() async throws -> DataLoadingResult {
        do {
            NetworkLogger.log(message: "Fetching properties from the API...")
            
            let properties: [Property] = try await networkService.fetchData(from: APIEndpoint.propertyList)
            self.properties = properties
            
            NetworkLogger.log(message: "Successfully loaded \(properties.count) properties", type: .success)
            
            return .online
        } catch {
            NetworkLogger.log(message: "Network fetch failed", type: .error)
            NetworkLogger.log(message: "Falling back to offline testing data")
            
            do {
                try await loadLocalProperties()
                return .offline
            } catch let localError {
                return .error(localError)
            }
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
        
        let data = try Data(contentsOf: url)
        let properties = try JSONDecoder().decode([Property].self, from: data)
        self.properties = properties
        
        NetworkLogger.log(message: "Successfully loaded \(properties.count) properties from local JSON", type: .success)
    }
    
}
