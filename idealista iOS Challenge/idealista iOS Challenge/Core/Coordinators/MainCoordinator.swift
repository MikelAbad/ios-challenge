//
//  MainCoordinator.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import UIKit
import CoreData

@MainActor
class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private let repositoryProvider: RepositoryProvider
    private let alertService: AlertService
    
    init(navigationController: UINavigationController,
         repositoryProvider: RepositoryProvider,
         alertService: AlertService) {
        self.navigationController = navigationController
        self.repositoryProvider = repositoryProvider
        self.alertService = alertService
    }
    
    func start() {
        showSplashScreen()
    }
}

private extension MainCoordinator {
    
    func showSplashScreen() {
        let viewModel = SplashViewModel(propertyRepository: repositoryProvider.getPropertyRepository())
        let viewController = SplashViewController(viewModel: viewModel)
        
        viewModel.onLoadingCompleted = { [weak self] fetchResult in
            guard let self else { return }
            
            switch fetchResult {
                case .online:
                    showPropertyList()
                case .offline:
                    alertService.showOfflineAlert(on: viewController) { [weak self] in
                        guard let self else { return }
                        showPropertyList()
                    }
                case .error(let error):
                    alertService.showErrorAlert(error: error, on: viewController)
            }
        }
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showPropertyList() {
        let viewModel = PropertyListViewModel(propertyRepository: repositoryProvider.getPropertyRepository())
        let viewController = PropertyListViewController(viewModel: viewModel)
        
        viewModel.onPropertySelected = { [weak self] property in
            guard let self else { return }
            showPropertyDetail(property: property)
        }
        
        UIView.transition(with: navigationController.view,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            guard let self else { return }
            navigationController.setViewControllers([viewController], animated: false)
        }, completion: nil)
    }
    
    func showPropertyDetail(property: Property) {
        let viewModel = PropertyDetailViewModel(property: property, repository: repositoryProvider.getPropertyDetailsRepository())
        let viewController = PropertyDetailViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
