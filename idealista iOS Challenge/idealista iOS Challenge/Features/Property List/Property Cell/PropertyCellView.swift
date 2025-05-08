//
//  PropertyCellView.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 30/04/2025.
//

import SwiftUI
import MapKit

struct PropertyCellView: View {
    @ObservedObject var viewModel: PropertyCellViewModel
    
    private let imageHeight: CGFloat = 200
    
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
                    imageHeight: imageHeight
                )
                .tag(0)
                
                ForEach(0..<viewModel.images.count, id: \.self) { index in
                    PropertyImageView(
                        image: viewModel.images[index],
                        imageHeight: imageHeight
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
                    }
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(viewModel.price)
                        .font(.headline)
                        .foregroundColor(.primaryTextColor)
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
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "shower")
                            .font(.caption)
                            .foregroundColor(.secondaryColor)
                        Text(viewModel.bathrooms)
                            .font(.caption)
                            .foregroundColor(.secondaryTextColor)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "ruler")
                            .font(.caption)
                            .foregroundColor(.secondaryColor)
                        Text(viewModel.size)
                            .font(.caption)
                            .foregroundColor(.secondaryTextColor)
                    }
                    
                    Text(viewModel.shortDescription)
                        .font(.caption)
                        .foregroundColor(.secondaryTextColor)
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
    
    var body: some View {
        AsyncImage(url: URL(string: image)) { status in
            switch status {
                case .empty:
                    ProgressView()
                        .tint(.primaryColor)
                        .frame(maxWidth: .infinity, maxHeight: imageHeight)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: imageHeight)
                        .clipped()
                case .failure:
                    Image(systemName: "photo.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: imageHeight)
                        .foregroundColor(.secondaryTextColor)
                        .padding()
                @unknown default:
                    EmptyView()
            }
        }
    }
}
