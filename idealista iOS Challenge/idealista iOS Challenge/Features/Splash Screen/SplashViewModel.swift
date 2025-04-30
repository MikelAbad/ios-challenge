//
//  SplashViewModel.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import Foundation

@MainActor
class SplashViewModel {
    private let propertyRepository: PropertyRepository
    
    var isLoading = true
    var error: Error?
    var onLoadingCompleted: ((DataLoadingResult) -> Void)?
    
    init(propertyRepository: PropertyRepository) {
        self.propertyRepository = propertyRepository
    }
    
    func loadData() async {
        isLoading = true
        
        let fetchResult = try? await propertyRepository.fetchProperties()
        
        isLoading = false
        
        let result = fetchResult ?? .error(NSError(domain: "SplashViewModel",
                                                   code: 777,
                                                   userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
        onLoadingCompleted?(result)
    }
}
