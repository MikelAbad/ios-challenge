//
//  ImageCache.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
    }
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }
    
    func saveImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
}
