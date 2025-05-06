//
//  PropertyDetailViewModel.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 06/05/2025.
//

import Foundation

@MainActor
class PropertyDetailViewModel {
    private let property: Property
    private let repository: PropertyDetailsRepository
    
    var propertyDetails: PropertyDetails?
    
    init(property: Property, repository: PropertyDetailsRepository) {
        self.property = property
        self.repository = repository
    }
    
    var propertyCode: String {
        property.propertyCode
    }
    
    var price: String {
        if let propertyDetails {
            return "\(propertyDetails.priceInfo.amount)\(propertyDetails.priceInfo.currencySuffix)"
        }
        return "\(property.priceInfo.price.amount)\(property.priceInfo.price.currencySuffix)"
    }
    
    var fullDescription: String {
        if let propertyDetails {
            return propertyDetails.propertyComment
        }
        return property.description
    }
    
    var shortDescription: String {
        if fullDescription.count <= 200 {
            return fullDescription
        }
        return String(fullDescription.prefix(200)) + "..."
    }
    
    var isFavorite: Bool {
        property.isFavorite
    }
    
    func loadPropertyDetails() async {
        do {
            propertyDetails = try await repository.fetchPropertyDetails(propertyCode: propertyCode)
        } catch {
            NetworkLogger.log(message: "Error loading property details: \(error)", type: .error)
        }
    }
}
