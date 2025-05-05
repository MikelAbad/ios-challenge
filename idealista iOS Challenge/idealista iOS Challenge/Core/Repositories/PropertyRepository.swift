//
//  PropertyRepository.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import Foundation
import CoreData

enum DataLoadingResult {
    case online
    case offline
    case error(Error)
}

@MainActor
class PropertyRepository {
    private let networkService: NetworkService
    private let propertyStorage: PropertyStorage?
    private var properties: [Property] = []
    
    init(networkService: NetworkService, coreDataStack: NSPersistentContainer?) {
        self.networkService = networkService
        
        if let coreDataStack {
            self.propertyStorage = PropertyStorage(coreDataStack: coreDataStack)
        } else {
            self.propertyStorage = nil
        }
    }
    
    func fetchProperties() async throws -> DataLoadingResult {
        do {
            NetworkLogger.log(message: "Fetching properties from the API...")
            
            let properties: [Property] = try await networkService.fetchData(from: APIEndpoint.propertyList)
            self.properties = properties
            
            updateFavoritesStatus()
            
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
    
    func toggleFavorite(propertyCode: String) {
        guard let propertyStorage,
              let index = properties.firstIndex(where: { $0.propertyCode == propertyCode }) else {
            return
        }
        
        let isFavorite = propertyStorage.isFavoriteProperty(propertyCode: propertyCode)
        
        if isFavorite {
            propertyStorage.removeFavoriteProperty(propertyCode: propertyCode)
            properties[index].isFavorite = false
            properties[index].favoriteDate = nil
        } else {
            let currentDate = Date()
            propertyStorage.saveFavoriteProperty(propertyCode: propertyCode, date: currentDate)
            properties[index].isFavorite = true
            properties[index].favoriteDate = currentDate
        }
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
        
        updateFavoritesStatus()
        
        NetworkLogger.log(message: "Successfully loaded \(properties.count) properties from local JSON", type: .success)
    }
    
    func updateFavoritesStatus() {
        guard let propertyStorage else { return }
        
        let favorites = propertyStorage.getAllFavoriteProperties()
        
        for i in 0..<properties.count {
            let propertyCode = properties[i].propertyCode
            
            if let favoriteInfo = favorites.first(where: { $0.propertyCode == propertyCode }) {
                properties[i].isFavorite = true
                properties[i].favoriteDate = favoriteInfo.favoriteDate
            } else {
                properties[i].isFavorite = false
                properties[i].favoriteDate = nil
            }
        }
    }
    
}
