//
//  PropertyImageCell.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import UIKit

class PropertyImageCell: UICollectionViewCell {
    static let reuseIdentifier = "PropertyImageCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageURL: URL?, accessibilityLabel: String?) {
        imageView.image = UIImage(systemName: "photo")
        imageView.accessibilityLabel = accessibilityLabel
        
        guard let imageURL else {
            imageView.image = UIImage(systemName: "photo.badge.exclamationmark")
            imageView.tintColor = .secondaryTextColor
            imageView.accessibilityLabel = "propertyDetail.imageError".localized()
            return
        }
        
        if let cachedImage = ImageCache.shared.image(for: imageURL) {
            imageView.image = cachedImage
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                if let image = UIImage(data: data) {
                    ImageCache.shared.saveImage(image, for: imageURL)
                    
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        imageView.image = image
                    }
                }
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    imageView.image = UIImage(systemName: "photo.badge.exclamationmark")
                    imageView.tintColor = .secondaryTextColor
                    imageView.accessibilityLabel = "propertyDetail.imageError".localized()
                }
            }
        }
    }
}

private extension PropertyImageCell {
    
    func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
