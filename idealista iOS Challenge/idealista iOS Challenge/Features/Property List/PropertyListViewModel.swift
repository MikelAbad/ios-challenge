//
//  PropertyListViewModel.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 30/04/2025.
//

import Foundation

@MainActor
class PropertyListViewModel {
    private let propertyRepository: PropertyRepository
    
    var properties: [Property] = []
    var onPropertySelected: ((Property) -> Void)?
    
    init(propertyRepository: PropertyRepository) {
        self.propertyRepository = propertyRepository
        self.properties = propertyRepository.getProperties()
    }
    
    func selectProperty(at index: Int) {
        guard index < properties.count else { return }
        onPropertySelected?(properties[index])
    }
    
    func toggleFavorite(at index: Int) {
        guard index < properties.count else { return }
        
        let propertyCode = properties[index].propertyCode
        propertyRepository.toggleFavorite(propertyCode: propertyCode)
        
        properties = propertyRepository.getProperties()
    }
    
    func refreshProperties() async {
        do {
            properties = try await propertyRepository.refreshProperties()
        } catch {
            NetworkLogger.log(message: "Error refreshing properties", type: .error)
        }
    }
}
