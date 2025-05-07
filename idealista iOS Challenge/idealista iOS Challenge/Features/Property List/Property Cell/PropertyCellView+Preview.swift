//
//  PropertyCellView+Preview.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import SwiftUI

#Preview("Property Cell") {
    let property = PropertyCellView.createPropertyForPreview()
    let viewModel = PropertyCellViewModel(property: property) {
        print("Favorite button pressed")
    }
    PropertyCellView(viewModel: viewModel)
        .padding()
        .background(Color.backgroundColor)
}

fileprivate extension PropertyCellView {
    static func createPropertyForPreview() -> Property {
        Property(
            propertyCode: "4",
            thumbnail: "https://img4.idealista.com/blur/WEB_LISTING-M/0/id.pro.es.image.master/75/92/8d/1264272139.webp",
            floor: "4",
            price: 889000.0,
            priceInfo: PriceInfo(
                price: Price(
                    amount: 1000.0,
                    currencySuffix: "€/mes"
                )
            ),
            propertyType: "flat",
            operation: "rent",
            size: 94.0,
            exterior: true,
            rooms: 3,
            bathrooms: 2,
            address: "calle de la Povedilla",
            province: "Madrid",
            municipality: "Madrid",
            district: "Barrio de Salamanca",
            country: "es",
            neighborhood: "Goya",
            latitude: 40.4226243,
            longitude: -3.6719939,
            description: "Este exclusivo piso en venta...",
            multimedia: Multimedia(
                images: [
                    PropertyImage(
                        url: "https://img4.idealista.com/blur/WEB_LISTING-M/0/id.pro.es.image.master/75/92/8d/1264272139.webp",
                        tag: "livingRoom"
                    ),
                    PropertyImage(
                        url: "https://img4.idealista.com/blur/WEB_LISTING-M/0/id.pro.es.image.master/b1/8e/23/1264272140.webp",
                        tag: "livingRoom"
                    ),
                    PropertyImage(
                        url: "https://img4.idealista.com/blur/WEB_LISTING-M/0/id.pro.es.image.master/6c/1d/c7/1264272163.webp",
                        tag: "kitchen"
                    )
                ]
            ),
            features: Features(
                hasSwimmingPool: false,
                hasTerrace: false,
                hasAirConditioning: true,
                hasBoxRoom: false,
                hasGarden: false
            ),
            parkingSpace: ParkingSpace(
                hasParkingSpace: true,
                isParkingSpaceIncludedInPrice: true
            ),
            isFavorite: true,
            favoriteDate: Date()
        )
    }
}
