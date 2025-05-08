//
//  SceneDelegate.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let navigationController = UINavigationController()
        let networkService = NetworkService()
        let alertService = AlertService()
        let coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        let repositoryProvider = RepositoryProvider(networkService: networkService, coreDataStack: coreDataStack)
        
        
        mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            repositoryProvider: repositoryProvider,
            alertService: alertService
        )
        mainCoordinator?.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}
