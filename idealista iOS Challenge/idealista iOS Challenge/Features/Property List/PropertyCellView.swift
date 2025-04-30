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
                .foregroundColor(.primary)
            
            let shortDescription = "\(String(property.description.prefix(100))) ..."
            Text(shortDescription)
                .font(.caption)
        }
        .padding(.vertical, 12)
        .background(Color(UIColor.systemBackground))
    }
}
