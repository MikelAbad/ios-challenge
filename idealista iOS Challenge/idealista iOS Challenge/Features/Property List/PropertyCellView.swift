//
//  PropertyCellView.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 30/04/2025.
//

import SwiftUI

struct PropertyCellView: View {
    let property: Property
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack() {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(Int(property.price))€")
                    .font(.headline)
                    .foregroundColor(.primaryTextColor)
                
                let shortDescription = "\(String(property.description.prefix(100))) ..."
                Text(shortDescription)
                    .font(.caption)
                    .foregroundColor(.secondaryTextColor)
                
                HStack {
                    Button(action: onFavoriteToggle) {
                        Image(systemName: property.isFavorite ? "heart.fill" : "heart")
                            .font(.subheadline)
                            .foregroundColor(property.isFavorite ? .primaryColor : .secondaryColor)
                    }
                    
                    if property.isFavorite,
                       let favoriteDate = property.favoriteDate {
                        Text(favoriteDate.relativeFormat())
                            .font(.caption2)
                            .foregroundColor(.primaryTextColor)
                    }
                }
                .padding(.top, 12)
            }
            .padding([.vertical, .horizontal], 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.cellBackgroundColor)
        .cornerRadius(12)
        .padding(.horizontal, 10)
    }
}
