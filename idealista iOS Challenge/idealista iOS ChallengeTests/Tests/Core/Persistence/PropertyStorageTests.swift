//
//  PropertyStorageTests.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 09/05/2025.
//

import XCTest
import CoreData
@testable import idealista_iOS_Challenge

final class PropertyStorageTests: XCTestCase {
    
    private var sut: PropertyStorage!
    private var coreDataContainer: NSPersistentContainer!
    
    override func setUpWithError() throws {
        coreDataContainer = createInMemoryPersistentContainer()
        sut = PropertyStorage(coreDataStack: coreDataContainer)
    }
    
    override func tearDownWithError() throws {
        clearCoreDataEntities()
        sut = nil
        coreDataContainer = nil
    }
    
    func testSaveFavoriteProperty() throws {
        let propertyCode = "4"
        let date = Date()
        
        sut.saveFavoriteProperty(propertyCode: propertyCode, date: date)
        
        let isFavorite = sut.isFavoriteProperty(propertyCode: propertyCode)
        XCTAssertTrue(isFavorite, "Should be favorite")
        
        let favorites = sut.getAllFavoriteProperties()
        XCTAssertEqual(favorites.count, 1, "Should have one favorite")
        
        if let savedProperty = favorites.first {
            XCTAssertEqual(savedProperty.propertyCode, propertyCode, "Code should match")
            XCTAssertEqual(savedProperty.favoriteDate.timeIntervalSince1970, date.timeIntervalSince1970, accuracy: 0.001, "Dates should be approximate")
        }
    }
    
    func testSaveDuplicateFavoriteProperty() throws {
        let propertyCode = "4"
        let initialDate = Date(timeIntervalSince1970: 1000000)
        
        sut.saveFavoriteProperty(propertyCode: propertyCode, date: initialDate)
        
        let laterDate = Date(timeIntervalSince1970: 2000000)
        sut.saveFavoriteProperty(propertyCode: propertyCode, date: laterDate)
        
        let favorites = sut.getAllFavoriteProperties()
        XCTAssertEqual(favorites.count, 1, "Should have only one favorite")
        
        if let savedProperty = favorites.first {
            XCTAssertEqual(savedProperty.propertyCode, propertyCode, "Code should match")
            XCTAssertEqual(savedProperty.favoriteDate.timeIntervalSince1970, initialDate.timeIntervalSince1970, accuracy: 0.001, "Date should be the first one")
        }
    }
    
    func testRemoveFavoriteProperty() throws {
        let propertyCode = "4"
        sut.saveFavoriteProperty(propertyCode: propertyCode, date: Date())
        
        XCTAssertTrue(sut.isFavoriteProperty(propertyCode: propertyCode), "Should be favorite")
        
        sut.removeFavoriteProperty(propertyCode: propertyCode)
        
        XCTAssertFalse(sut.isFavoriteProperty(propertyCode: propertyCode), "Should not be favorite")
        
        let favorites = sut.getAllFavoriteProperties()
        XCTAssertEqual(favorites.count, 0, "Should have no favorites")
    }
    
    func testRemoveNonExistentProperty() throws {
        sut.removeFavoriteProperty(propertyCode: "NONEXISTENT")
        
        let favorites = sut.getAllFavoriteProperties()
        XCTAssertEqual(favorites.count, 0, "Should have no favorites and no errors")
    }
    
    func testGetAllFavoriteProperties() throws {
        let properties = [
            ("1", Date(timeIntervalSince1970: 1000000)),
            ("2", Date(timeIntervalSince1970: 2000000)),
            ("3", Date(timeIntervalSince1970: 3000000)),
            ("4", Date(timeIntervalSince1970: 4000000))
        ]
        
        for (code, date) in properties {
            sut.saveFavoriteProperty(propertyCode: code, date: date)
        }
        
        let favorites = sut.getAllFavoriteProperties()
        XCTAssertEqual(favorites.count, 4, "Should have four favorites")
        
        let codes = favorites.map { $0.propertyCode }
        XCTAssertTrue(codes.contains("1"), "Should contain 1")
        XCTAssertTrue(codes.contains("2"), "Should contain 2")
        XCTAssertTrue(codes.contains("3"), "Should contain 3")
        XCTAssertTrue(codes.contains("4"), "Should contain 4")
        XCTAssertFalse(codes.contains("5"), "Should not contain 5")
    }
    
    func testIsFavoriteProperty() throws {
        let propertyCode = "4"
        
        let initialState = sut.isFavoriteProperty(propertyCode: propertyCode)
        
        XCTAssertFalse(initialState, "Should not be favorite")
        
        sut.saveFavoriteProperty(propertyCode: propertyCode, date: Date())
        let afterSavingState = sut.isFavoriteProperty(propertyCode: propertyCode)
        
        XCTAssertTrue(afterSavingState, "Should be favorite")
        
        sut.removeFavoriteProperty(propertyCode: propertyCode)
        let finalState = sut.isFavoriteProperty(propertyCode: propertyCode)
        
        XCTAssertFalse(finalState, "Should not be favorite")
    }
    
    func testPropertyWithNilValues() throws {
        let context = coreDataContainer.viewContext
        let favoriteProperty = FavoriteProperty(context: context)
        favoriteProperty.propertyCode = nil
        favoriteProperty.favoriteDate = nil
        try context.save()
        
        let favorites = sut.getAllFavoriteProperties()
        
        XCTAssertEqual(favorites.count, 0, "Invalid entries should be filtered")
    }
    
}

private extension PropertyStorageTests {
    
    func createInMemoryPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "idealista_iOS_Challenge")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (description, error) in
            if let error {
                fatalError("Error creating in-memory persistent store: \(error.localizedDescription)")
            }
        }
        
        return container
    }
    
    func clearCoreDataEntities() {
        let context = coreDataContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteProperty.fetchRequest()
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                if let managedObject = object as? NSManagedObject {
                    context.delete(managedObject)
                }
            }
            
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Error clearing test data: \(error.localizedDescription)")
        }
    }
    
}
