//
//  PropertyCellViewModel.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import Foundation
import SwiftUI

// Assuming other types
enum PropertyType: String {
    case flat = "flat"
    case house = "house"
    case studio = "studio"
    case unknown
    
    init(from string: String) {
        self = PropertyType(rawValue: string.lowercased()) ?? .unknown
    }
    
    var name: String {
        switch self {
            case .flat:
                return "propertyList.flat".localized()
            case .house:
                return "propertyList.house".localized()
            case .studio:
                return "propertyList.studio".localized()
            case .unknown:
                return "propertyList.property".localized()
        }
    }
}

class PropertyCellViewModel: ObservableObject {
    private let property: Property
    private let onFavoriteToggle: () -> Void
    
    @Published var currentImageIndex: Int = 0
    
    var thumbnail: String {
        property.thumbnail
    }
    
    var images: [String] {
        property.multimedia.images.prefix(4).map { $0.url }
    }
    
    var title: String {
        let propertyType = PropertyType(from: property.propertyType)
        return String(format: "propertyList.propertyIn".localized(),
                      propertyType.name,
                      property.address.localizedCapitalized)
    }
    
    var price: String {
        "\(Int(property.priceInfo.price.amount))"
    }
    
    var parkingSpace: String? {
        if property.parkingSpace?.hasParkingSpace == true {
            if property.parkingSpace?.isParkingSpaceIncludedInPrice == true {
                return "propertyList.parkingSpaceIncluded".localized()
            }
            return "propertyList.hasParkingSpace".localized()
        }
        return nil
    }
    
    var currencySuffix: String {
        property.priceInfo.price.currencySuffix
    }
    
    var rooms: String {
        "\(property.rooms)"
    }
    
    var bathrooms: String {
        "\(property.bathrooms)"
    }
    
    var size: String {
        "\(Int(property.size)) m²"
    }
    
    var latitude: Double {
        property.latitude
    }
    
    var longitude: Double {
        property.longitude
    }
    
    var shortDescription: String {
        let type = PropertyType(from: property.propertyType)
        switch type {
            case .flat:
                let exteriorStatus = property.exterior ? "propertyList.exterior" : "propertyList.interior"
                return String(format: "propertyList.description".localized(),
                              property.floor,
                              exteriorStatus.localized())
            case .house:
                return "House"
            case .studio:
                return "Studio"
            case .unknown:
                return ""
        }
    }
    
    var isFavorite: Bool {
        property.isFavorite
    }
    
    var favoriteDate: String? {
        guard isFavorite, let date = property.favoriteDate else { return nil }
        return date.relativeFormat()
    }
    
    var mapAccessibilityLabel: String {
        "propertyList.mapTag".localized()
    }
    
    var thumbnailAccessibilityLabel: String {
        "propertyList.thumbnailTag".localized()
    }
    
    init(property: Property, onFavoriteToggle: @escaping () -> Void) {
        self.property = property
        self.onFavoriteToggle = onFavoriteToggle
    }
    
    func toggleFavorite() {
        onFavoriteToggle()
    }
    
    func imageAccessibilityLabel(at index: Int) -> String {
        guard index < property.multimedia.images.count else { return "" }
        return property.multimedia.images[index].tag
    }
}
