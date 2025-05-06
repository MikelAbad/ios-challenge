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
    
    var onLoadingCompleted: ((DataLoadingResult) -> Void)?
    
    init(propertyRepository: PropertyRepository) {
        self.propertyRepository = propertyRepository
    }
    
    func loadData() async {
        let fetchResult = try? await propertyRepository.fetchProperties()
        let result = fetchResult ?? .error(NSError(domain: "SplashViewModel",
                                                   code: 777,
                                                   userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
        onLoadingCompleted?(result)
    }
}
