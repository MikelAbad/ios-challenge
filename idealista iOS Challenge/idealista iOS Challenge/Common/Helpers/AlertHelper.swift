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
        
        let okAction = UIAlertAction(title: "alert_ok".localized(), style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true)
    }
    
    static func showOfflineAlert(on viewController: UIViewController,
                                 completion: @escaping () -> Void) {
        let title = "alert_warning".localized()
        let message = "alert_offline_message".localized()
        
        showAlert(title: title,
                  message: message,
                  on: viewController,
                  completion: completion)
    }
    
    static func showCriticalErrorAlert(on viewController: UIViewController) {
        let title = "alert_error".localized()
        let message = "alert_error_message".localized()
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .actionSheet)
        
        viewController.present(alertController, animated: true)
    }
    
}
