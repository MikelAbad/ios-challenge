//
//  PropertyCellView.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 30/04/2025.
//

import SwiftUI
import MapKit

struct PropertyCellView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var viewModel: PropertyCellViewModel
    
    var baseImageHeight: CGFloat = 200
    var imageHeight: CGFloat {
        horizontalSizeClass == .regular ? baseImageHeight * 2 : baseImageHeight
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TabView(selection: $viewModel.currentImageIndex) {
                
                ZStack {
                    if viewModel.currentImageIndex == -1 {
                        PropertyMapView(
                            latitude: viewModel.latitude,
                            longitude: viewModel.longitude,
                            title: viewModel.title
                        )
                        .accessibilityLabel(viewModel.mapAccessibilityLabel)
                    } else {
                        Image(systemName: "map.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.secondaryColor)
                            .padding(50)
                            .frame(maxWidth: .infinity, maxHeight: imageHeight)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: imageHeight)
                .tag(-1)
                
                PropertyImageView(
                    image: viewModel.thumbnail,
                    imageHeight: imageHeight,
                    accessibilityLabel: viewModel.thumbnailAccessibilityLabel
                )
                .tag(0)
                
                ForEach(0..<viewModel.images.count, id: \.self) { index in
                    PropertyImageView(
                        image: viewModel.images[index],
                        imageHeight: imageHeight,
                        accessibilityLabel: viewModel.imageAccessibilityLabel(at: index)
                    )
                    .tag(index + 1)
                }
                
            }
            .frame(height: imageHeight)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(viewModel.title)
                        .font(.subheadline)
                        .foregroundColor(.primaryTextColor)
                        .accessibilityIdentifier(AccessibilityIdentifiers.PropertyList.titleLabel)
                    
                    Spacer()
                    
                    HStack {
                        if let favoriteDate = viewModel.favoriteDate {
                            Text(favoriteDate)
                                .font(.caption2)
                                .foregroundColor(.primaryTextColor)
                        }
                        
                        Button(action: {
                            viewModel.toggleFavorite()
                        }) {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                .font(.subheadline)
                                .foregroundColor(viewModel.isFavorite ? .primaryColor : .secondaryColor)
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.PropertyList.favoriteButton)
                    }
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(viewModel.price)
                        .font(.headline)
                        .foregroundColor(.primaryTextColor)
                        .accessibilityIdentifier(AccessibilityIdentifiers.PropertyList.priceLabel)
                    Text(viewModel.currencySuffix)
                        .font(.caption)
                        .foregroundColor(.primaryTextColor)
                    if let parkingSpace = viewModel.parkingSpace {
                        Text(parkingSpace)
                            .font(.caption)
                            .foregroundColor(.primaryTextColor)
                            .padding(.leading, 8)
                    }
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "bed.double")
                            .font(.caption)
                            .foregroundColor(.secondaryColor)
                        Text(viewModel.rooms)
                            .font(.caption)
                            .foregroundColor(.secondaryTextColor)
                            .accessibilityIdentifier(AccessibilityIdentifiers.PropertyList.roomsLabel)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "shower")
                            .font(.caption)
                            .foregroundColor(.secondaryColor)
                        Text(viewModel.bathrooms)
                            .font(.caption)
                            .foregroundColor(.secondaryTextColor)
                            .accessibilityIdentifier(AccessibilityIdentifiers.PropertyList.bathroomsLabel)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "ruler")
                            .font(.caption)
                            .foregroundColor(.secondaryColor)
                        Text(viewModel.size)
                            .font(.caption)
                            .foregroundColor(.secondaryTextColor)
                            .accessibilityIdentifier(AccessibilityIdentifiers.PropertyList.sizeLabel)
                    }
                    
                    Text(viewModel.shortDescription)
                        .font(.caption)
                        .foregroundColor(.secondaryTextColor)
                        .accessibilityIdentifier(AccessibilityIdentifiers.PropertyList.descriptionLabel)
                }
                .padding(.vertical, 8)
            }
            .padding([.vertical, .horizontal], 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.cellBackgroundColor)
        .cornerRadius(12)
        .padding(.horizontal, 10)
    }
}

struct PropertyMapView: UIViewRepresentable {
    let latitude: Double
    let longitude: Double
    let title: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = false
        
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        mapView.setRegion(region, animated: false)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update map if needed
    }
}

struct PropertyImageView: View {
    let image: String
    let imageHeight: CGFloat
    let accessibilityLabel: String
    
    var body: some View {
        AsyncImage(url: URL(string: image)) { status in
            switch status {
                case .empty:
                    ProgressView()
                        .tint(.primaryColor)
                        .frame(maxWidth: .infinity, maxHeight: imageHeight)
                        .accessibilityLabel("propertyList.imageLoading".localized())
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: imageHeight)
                        .clipped()
                        .accessibilityLabel(accessibilityLabel)
                case .failure:
                    Image(systemName: "photo.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: imageHeight)
                        .foregroundColor(.secondaryTextColor)
                        .padding()
                        .accessibilityLabel("propertyList.imageError".localized())
                @unknown default:
                    EmptyView()
            }
        }
    }
}
