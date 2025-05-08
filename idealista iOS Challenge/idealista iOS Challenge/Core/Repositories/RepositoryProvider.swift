//
//  RepositoryProvider.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import Foundation
import CoreData

@MainActor
class RepositoryProvider {
    private let networkService: NetworkService
    private let coreDataStack: NSPersistentContainer?
    
    private lazy var propertyRepository = PropertyRepository(networkService: networkService, coreDataStack: coreDataStack)
    private lazy var propertyDetailsRepository = PropertyDetailsRepository(networkService: networkService)
    
    init(networkService: NetworkService, coreDataStack: NSPersistentContainer?) {
        self.networkService = networkService
        self.coreDataStack = coreDataStack
    }
    
    func getPropertyRepository() -> PropertyRepository {
        propertyRepository
    }
    
    func getPropertyDetailsRepository() -> PropertyDetailsRepository {
        propertyDetailsRepository
    }
}
