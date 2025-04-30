//
//  MainCoordinator.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import UIKit

@MainActor
class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private let networkService = NetworkService()
    private lazy var propertyRepository = PropertyRepository(networkService: networkService)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSplashScreen()
    }
    
    func showSplashScreen() {
        let viewModel = SplashViewModel(propertyRepository: propertyRepository)
        let viewController = SplashViewController(viewModel: viewModel)
        
        viewModel.onLoadingCompleted = { [weak self] in
            //TODO: Load property list view
        }
        
        navigationController.setViewControllers([viewController], animated: false)
    }
}
