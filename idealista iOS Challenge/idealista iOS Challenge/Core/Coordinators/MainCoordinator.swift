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
}

private extension MainCoordinator {
    
    func showSplashScreen() {
        let viewModel = SplashViewModel(propertyRepository: propertyRepository)
        let viewController = SplashViewController(viewModel: viewModel)
        
        viewModel.onLoadingCompleted = { [weak self] fetchResult in
            guard let self else { return }
            
            switch fetchResult {
                case .online:
                    showPropertyList()
                case .offline:
                    showOfflineAlert(on: viewController) { [weak self] in
                        guard let self else { return }
                        showPropertyList()
                    }
                case .error(let error):
                    showErrorAlert(error: error, on: viewController)
            }
        }
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showPropertyList() {
        let viewModel = PropertyListViewModel(propertyRepository: propertyRepository)
        let viewController = PropertyListViewController(viewModel: viewModel)
        
        viewModel.onPropertySelected = { [weak self] property in
            //TODO: Go to detail view
        }
        
        UIView.transition(with: navigationController.view,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            guard let self else { return }
            navigationController.setViewControllers([viewController], animated: false)
        }, completion: nil)
    }
    
    func showOfflineAlert(on viewController: UIViewController, completion: @escaping () -> Void) {
        AlertHelper.showOfflineAlert(on: viewController, completion: completion)
    }
    
    func showErrorAlert(error: Error, on viewController: UIViewController) {
        AlertHelper.showCriticalErrorAlert(on: viewController)
    }
    
}
