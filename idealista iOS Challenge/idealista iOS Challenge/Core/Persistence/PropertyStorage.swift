//
//  PropertyStorage.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 05/05/2025.
//

import Foundation
import CoreData

class PropertyStorage {
    private let coreDataStack: NSPersistentContainer
    
    init(coreDataStack: NSPersistentContainer) {
        self.coreDataStack = coreDataStack
    }
    
    func saveFavoriteProperty(propertyCode: String, date: Date) {
        let context = coreDataStack.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteProperty> = FavoriteProperty.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "propertyCode == %@", propertyCode)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            guard results.first == nil else { return }
            
            let favoriteProperty = FavoriteProperty(context: context)
            favoriteProperty.propertyCode = propertyCode
            favoriteProperty.favoriteDate = date
            
            try context.save()
        } catch {
            print("Error saving favorite property: \(error.localizedDescription)")
        }
    }
    
    func removeFavoriteProperty(propertyCode: String) {
        let context = coreDataStack.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteProperty> = FavoriteProperty.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "propertyCode == %@", propertyCode)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let favoriteToRemove = results.first {
                context.delete(favoriteToRemove)
                try context.save()
            }
        } catch {
            print("Error deleting favorite property: \(error.localizedDescription)")
        }
    }
    
    func getAllFavoriteProperties() -> [FavoritePropertyInfo] {
        let context = coreDataStack.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteProperty> = FavoriteProperty.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { favorite in
                guard let propertyCode = favorite.propertyCode,
                      let favoriteDate = favorite.favoriteDate else {
                    return nil
                }
                return FavoritePropertyInfo(propertyCode: propertyCode, favoriteDate: favoriteDate)
            }
        } catch {
            print("Error retrieving favorites: \(error.localizedDescription)")
            return []
        }
    }
    
    func isFavoriteProperty(propertyCode: String) -> Bool {
        let context = coreDataStack.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteProperty> = FavoriteProperty.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "propertyCode == %@", propertyCode)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorite: \(error.localizedDescription)")
            return false
        }
    }
    
}

struct FavoritePropertyInfo {
    let propertyCode: String
    let favoriteDate: Date
}
