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
    var onLoadingCompleted: (() -> Void)?
    
    init(propertyRepository: PropertyRepository) {
        self.propertyRepository = propertyRepository
    }
    
    func loadData() async {
        isLoading = true
        
        do {
            try await propertyRepository.fetchProperties()
            
            isLoading = false
            onLoadingCompleted?()
        } catch {
            self.error = error
            isLoading = false
            onLoadingCompleted?()
        }
    }
}
