//
//  PropertyCellView.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 30/04/2025.
//

import SwiftUI

struct PropertyCellView: View {
    let property: Property
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(Int(property.price))€")
                .font(.headline)
                .foregroundColor(.primaryTextColor)
            
            let shortDescription = "\(String(property.description.prefix(100))) ..."
            Text(shortDescription)
                .font(.caption)
                .foregroundColor(.secondaryTextColor)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cellBackgroundColor)
        .cornerRadius(12)
    }
}
