//
//  Property.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import Foundation

struct Property: Decodable {
    let propertyCode: String
    let thumbnail: String
    let floor: String
    let price: Double
    let priceInfo: PriceInfo
    let propertyType: String
    let operation: String
    let size: Double
    let exterior: Bool
    let rooms: Int
    let bathrooms: Int
    let address: String
    let province: String
    let municipality: String
    let district: String
    let country: String
    let neighborhood: String
    let latitude: Double
    let longitude: Double
    let description: String
    let multimedia: Multimedia
    let features: Features
    let parkingSpace: ParkingSpace?
    
    var isFavorite: Bool = false
    var favoriteDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case propertyCode, thumbnail, floor, price, priceInfo
        case propertyType, operation, size, exterior, rooms, bathrooms
        case address, province, municipality, district, country
        case neighborhood, latitude, longitude, description
        case multimedia, features, parkingSpace
    }
}

struct PriceInfo: Decodable {
    let price: Price
}

struct Price: Decodable {
    let amount: Double
    let currencySuffix: String
}

struct Multimedia: Decodable {
    let images: [PropertyImage]
}

struct PropertyImage: Decodable {
    let url: String
    let tag: String
}

struct Features: Decodable {
    let hasSwimmingPool: Bool?
    let hasTerrace: Bool?
    let hasAirConditioning: Bool?
    let hasBoxRoom: Bool?
    let hasGarden: Bool?
}

struct ParkingSpace: Decodable {
    let hasParkingSpace: Bool?
    let isParkingSpaceIncludedInPrice: Bool?
}
