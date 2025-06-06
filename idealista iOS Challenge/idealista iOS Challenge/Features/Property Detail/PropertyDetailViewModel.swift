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
    
    var isFavorite: Bool {
        property.isFavorite
    }
    
    var images: [DetailPropertyImage] {
        propertyDetails?.multimedia.images ?? []
    }
    
    var imagesCount: Int {
        images.count
    }
    
    var propertyType: PropertyType {
        PropertyType(from: propertyDetails?.extendedPropertyType ?? property.propertyType)
    }
    
    var title: String {
        String(format: "propertyDetail.propertyIn".localized(),
               propertyType.name,
               property.address.localizedCapitalized)
    }
    
    var subtitle: String {
        String(format: "propertyDetail.address".localized(),
               property.neighborhood,
               property.district,
               property.municipality)
    }
    
    var price: String {
        "\(Int(propertyDetails?.priceInfo.amount ?? property.priceInfo.price.amount))"
    }
    
    var currencySuffix: String {
        propertyDetails?.priceInfo.currencySuffix ?? property.priceInfo.price.currencySuffix
    }
    
    var rooms: String {
        "\(propertyDetails?.moreCharacteristics.roomNumber ?? property.rooms)"
    }
    
    var bathrooms: String {
        "\(propertyDetails?.moreCharacteristics.bathNumber ?? property.bathrooms)"
    }
    
    var size: String {
        let sizeValue = propertyDetails?.moreCharacteristics.constructedArea ?? property.size
        return "\(Int(sizeValue)) m²"
    }
    
    var shortPropertyDescription: String {
        let type = propertyType
        switch type {
            case .flat:
                let floor = propertyDetails?.moreCharacteristics.floor ?? property.floor
                let isExterior = propertyDetails?.moreCharacteristics.exterior ?? property.exterior
                let exteriorStatus = isExterior ? "propertyDetail.exterior" : "propertyDetail.interior"
                return String(format: "propertyDetail.description".localized(),
                              floor,
                              exteriorStatus.localized())
            case .house:
                return "House"
            case .studio:
                return "Studio"
            case .unknown:
                return ""
        }
    }
    
    var parkingSpace: String? {
        if property.parkingSpace?.hasParkingSpace == true {
            if property.parkingSpace?.isParkingSpaceIncludedInPrice == true {
                return "propertyDetail.parkingSpaceIncluded".localized()
            }
            return "propertyDetail.hasParkingSpace".localized()
        }
        return nil
    }
    
    var descriptionTitle: String {
        "propertyDetail.comment".localized()
    }
    
    var hasElevator: Bool {
        propertyDetails?.moreCharacteristics.lift ?? false
    }
    
    var hasStorageRoom: Bool {
        propertyDetails?.moreCharacteristics.boxroom ?? property.features.hasBoxRoom ?? false
    }
    
    var hasAirConditioning: Bool {
        property.features.hasAirConditioning ?? false
    }
    
    var energyCertificateTitle: String {
        propertyDetails?.energyCertification.title ?? "propertyDetail.energyCertificate".localized()
    }
    
    var energyCertificateConsumption: String {
        propertyDetails?.energyCertification.energyConsumption.type.uppercased() ?? "propertyDetail.notAvailable".localized()
    }
    
    var energyCertificateEmissions: String {
        propertyDetails?.energyCertification.emissions.type.uppercased() ?? "propertyDetail.notAvailable".localized()
    }
    
    var communityCosts: String {
        if let costs = propertyDetails?.moreCharacteristics.communityCosts, costs > 0 {
            return "\(Int(costs)) \("propertyDetail.monthCost".localized())"
        }
        return "propertyDetail.notAvailable".localized()
    }
    
    var basicFeatures: [String] {
        var features = [String]()
        
        features.append("\(size)")
        features.append("\(rooms) \("propertyDetail.rooms".localized())")
        features.append("\(bathrooms) \("propertyDetail.bathrooms".localized())")
        
        if let parkingSpace {
            features.append(parkingSpace)
        }
        
        if hasStorageRoom {
            features.append("propertyDetail.boxroom".localized())
        }
        
        if hasAirConditioning {
            features.append("propertyDetail.airConditioning".localized())
        }
        
        features.append("\("propertyDetail.community".localized()) \(communityCosts)")
        
        return features
    }
    
    var buildingFeatures: [String] {
        var features = [String]()
        
        features.append(shortPropertyDescription)
        
        if hasElevator {
            features.append("propertyDetail.hasElevator".localized())
        } else {
            features.append("propertyDetail.noElevator".localized())
        }
        
        return features
    }
    
    var energyCertificationItems: [String] {
        var features = [String]()
        
        features.append("\("propertyDetail.energyConsumption".localized()): \(energyCertificateConsumption.uppercased())")
        features.append("\("propertyDetail.energyEmission".localized()): \(energyCertificateEmissions.uppercased())")
        
        return features
    }
    
    var shortDescription: String {
        if fullDescription.count <= 200 {
            return fullDescription
        }
        return String(fullDescription.prefix(200)) + "..."
    }
    
    var fullDescription: String {
        if let propertyDetails {
            return propertyDetails.propertyComment
        }
        return property.description
    }
    
    func loadPropertyDetails() async {
        do {
            propertyDetails = try await repository.fetchPropertyDetails(propertyCode: propertyCode)
        } catch {
            NetworkLogger.log(message: "Error loading property details: \(error)", type: .error)
        }
    }
    
    func imageURL(at index: Int) -> URL? {
        guard index < images.count else { return nil }
        return URL(string: images[index].url)
    }
    
    func imageAccessibilityLabel(at index: Int) -> String? {
        guard index < images.count else { return nil }
        return images[index].tag
    }
}
