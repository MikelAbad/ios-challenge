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
        
        viewModel.onLoadingCompleted = { [weak self] fetchResult in
            guard let self else { return }
            
            switch fetchResult {
                case .online:
                    //TODO: Go to property list view
                    print("Debug: Data fetched online")
                case .offline:
                    showOfflineAlert(on: viewController) {
                        //TODO: Go to property list view
                        print("Debug: Data fetched offline")
                    }
                case .error(let error):
                    showErrorAlert(error: error, on: viewController)
            }
        }
        
        navigationController.setViewControllers([viewController], animated: false)
    }
}

private extension MainCoordinator {
    
    func showOfflineAlert(on viewController: UIViewController, completion: @escaping () -> Void) {
        AlertHelper.showOfflineAlert(on: viewController, completion: completion)
    }
    
    func showErrorAlert(error: Error, on viewController: UIViewController) {
        AlertHelper.showCriticalErrorAlert(on: viewController)
    }
    
}
