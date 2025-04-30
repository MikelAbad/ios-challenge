//
//  AlertHelper.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 30/04/2025.
//

import UIKit

class AlertHelper {
    
    static func showAlert(title: String,
                          message: String,
                          on viewController: UIViewController,
                          completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true)
    }
    
    static func showOfflineAlert(on viewController: UIViewController,
                                 completion: @escaping () -> Void) {
        let title = "Warning"
        let message = "App couldn't connect to the service and data will be loaded offline"
        
        showAlert(title: title,
                  message: message,
                  on: viewController,
                  completion: completion)
    }
    
    static func showCriticalErrorAlert(on viewController: UIViewController) {
        let title = "Error"
        let message = "Critical error. Restart the app"
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .actionSheet)
        
        viewController.present(alertController, animated: true)
    }
    
}
