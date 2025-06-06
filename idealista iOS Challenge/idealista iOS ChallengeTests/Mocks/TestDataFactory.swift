//
//  TestDataFactory.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 10/05/2025.
//

import UIKit
@testable import idealista_iOS_Challenge

class TestDataFactory {
    
    static func createProperty(
        code: String = "4",
        propertyType: String = "flat",
        exterior: Bool = true,
        isFavorite: Bool = false,
        hasParkingSpace: Bool = false,
        parkingIncluded: Bool = false,
        floor: String = "1",
        price: Double = 100000,
        rooms: Int = 3,
        bathrooms: Int = 2,
        size: Double = 80
    ) -> Property {
        var property = Property(
            propertyCode: code,
            thumbnail: "https://example.com/\(code).jpg",
            floor: floor,
            price: price,
            priceInfo: PriceInfo(price: Price(amount: price, currencySuffix: "€")),
            propertyType: propertyType,
            operation: "sale",
            size: size,
            exterior: exterior,
            rooms: rooms,
            bathrooms: bathrooms,
            address: "Test Street",
            province: "Madrid",
            municipality: "Madrid",
            district: "Centro",
            country: "ES",
            neighborhood: "Test Neighborhood",
            latitude: 40.416775,
            longitude: -3.703790,
            description: "Venta.Piso EN EXCLUSIVA. Castellana. Se ofrece en venta vivienda de 133 m² en el exclusivo Barrio de Salamanca, zona Castellana, con 3 dormitorios (uno en suite), 2 baños, amplio salón comedor, cocina independiente con office y lavadero. Cuenta con un amplio patio privado y armarios empotrados en todas las habitaciones. Reformado para optimizar el espacio, ofrece gran potencial para personalizarlo. Ubicado en una de las zonas más exclusivas de Madrid, el Barrio de Salamanca, en la cotizada zona de Castellana, se encuentra este espacioso piso en venta de 133 m² que ofrece una oportunidad única para quienes buscan una vivienda que combine comodidad, ubicación y potencial de actualización.",
            multimedia: Multimedia(images: [
                PropertyImage(url: "https://example.com/img1_\(code).jpg", tag: "main"),
                PropertyImage(url: "https://example.com/img2_\(code).jpg", tag: "kitchen")
            ]),
            features: Features(
                hasSwimmingPool: false,
                hasTerrace: true,
                hasAirConditioning: true,
                hasBoxRoom: true,
                hasGarden: false
            ),
            parkingSpace: hasParkingSpace ? ParkingSpace(
                hasParkingSpace: true,
                isParkingSpaceIncludedInPrice: parkingIncluded
            ) : nil
        )
        
        property.isFavorite = isFavorite
        property.favoriteDate = isFavorite ? Date() : nil
        
        return property
    }
    
    static func createPropertyDetails(
        adid: Int = 1,
        price: Double = 100000,
        hasElevator: Bool = true,
        communityCosts: Double = 50,
        rooms: Int = 3,
        bathrooms: Int = 2
    ) -> PropertyDetails {
        PropertyDetails(
            adid: adid,
            price: price,
            priceInfo: DetailPriceInfo(amount: price, currencySuffix: "€"),
            operation: "sale",
            propertyType: "flat",
            extendedPropertyType: "flat",
            homeType: "home",
            state: "good",
            multimedia: DetailMultimedia(images: [
                DetailPropertyImage(url: "https://example.com/detail1.jpg", tag: "main"),
                DetailPropertyImage(url: "https://example.com/detail2.jpg", tag: "kitchen"),
                DetailPropertyImage(url: "https://example.com/detail3.jpg", tag: "bathroom")
            ]),
            propertyComment: "Venta.Piso EN EXCLUSIVA. Castellana. Se ofrece en venta vivienda de 133 m² en el exclusivo Barrio de Salamanca, zona Castellana, con 3 dormitorios (uno en suite), 2 baños, amplio salón comedor, cocina independiente con office y lavadero. Cuenta con un amplio patio privado y armarios empotrados en todas las habitaciones. Reformado para optimizar el espacio, ofrece gran potencial para personalizarlo. Ubicado en una de las zonas más exclusivas de Madrid, el Barrio de Salamanca, en la cotizada zona de Castellana, se encuentra este espacioso piso en venta de 133 m² que ofrece una oportunidad única para quienes buscan una vivienda que combine comodidad, ubicación y potencial de actualización.",
            ubication: Ubication(latitude: 40.416775, longitude: -3.703790),
            country: "ES",
            moreCharacteristics: MoreCharacteristics(
                communityCosts: communityCosts,
                roomNumber: rooms,
                bathNumber: bathrooms,
                exterior: true,
                housingFurnitures: "",
                agencyIsABank: false,
                energyCertificationType: "E",
                flatLocation: "street",
                modificationDate: 0,
                constructedArea: 80,
                lift: hasElevator,
                boxroom: true,
                isDuplex: false,
                floor: "1",
                status: "good"
            ),
            energyCertification: EnergyCertification(
                title: "Energy Certificate",
                energyConsumption: EnergyLevel(type: "E"),
                emissions: EnergyLevel(type: "F")
            )
        )
    }
    
    static func createTestImage(color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    
}
