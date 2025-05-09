//
//  ImageCacheTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import XCTest
@testable import idealista_iOS_Challenge

final class ImageCacheTests: XCTestCase {
    
    var sut: ImageCache!
    
    override func setUpWithError() throws {
        sut = ImageCache.shared
        sut.clearCache()
    }
    
    override func tearDownWithError() throws {
        sut.clearCache()
    }
    
    func testSaveAndRetrieveImage() throws {
        let url = URL(string: "https://domain.com/image.png")!
        let image = createTestImage(color: .red, size: CGSize(width: 100, height: 100))
        
        sut.saveImage(image, for: url)
        
        let retrievedImage = sut.image(for: url)
        XCTAssertNotNil(retrievedImage, "Image should be retrieved from cache")
        
        XCTAssertEqual(retrievedImage?.size.width, image.size.width, "Width should be the same")
        XCTAssertEqual(retrievedImage?.size.height, image.size.height, "Height should be the same")
    }
    
    func testImageNotInCache() throws {
        let url = URL(string: "https://domain.com/fakeimage.jpg")!
        
        let image = sut.image(for: url)
        
        XCTAssertNil(image, "Image should not be retrieved from the cache")
    }
    
    func testOverwriteImage() throws {
        let url = URL(string: "https://example.com/replace.jpg")!
        let redImage = createTestImage(color: .red, size: CGSize(width: 50, height: 50))
        let blueImage = createTestImage(color: .blue, size: CGSize(width: 100, height: 100))
        
        sut.saveImage(redImage, for: url)
        sut.saveImage(blueImage, for: url)
        
        let retrievedImage = sut.image(for: url)
        XCTAssertNotNil(retrievedImage, "Image should be retrieved from cache")
        XCTAssertEqual(retrievedImage?.size.width, blueImage.size.width, "It should have second image width")
        XCTAssertEqual(retrievedImage?.size.height, blueImage.size.height, "It should have second image height")
    }
    
}

private extension ImageCacheTests {
    func createTestImage(color: UIColor, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
