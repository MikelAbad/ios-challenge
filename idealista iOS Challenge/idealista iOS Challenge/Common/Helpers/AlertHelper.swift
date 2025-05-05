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
        let alertController = createAlertController(title: title, message: message)
        
        configureAttributedTitle(title, for: alertController)
        configureAttributedMessage(message, for: alertController)
        addOkAction(to: alertController, completion: completion)
        
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
        
        configureAttributedTitle(title, for: alertController)
        configureAttributedMessage(message, for: alertController)
        
        viewController.present(alertController, animated: true)
    }
    
}

private extension AlertHelper {
    
    static func createAlertController(title: String, message: String) -> UIAlertController {
        UIAlertController(title: title,
                          message: message,
                          preferredStyle: .alert)
    }
    
    static func configureAttributedTitle(_ title: String, for alertController: UIAlertController) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.primaryTextColor,
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
    }

    static func configureAttributedMessage(_ message: String, for alertController: UIAlertController) {
        let messageAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryTextColor,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ]
        let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
    }
    
    static func addOkAction(to alertController: UIAlertController, completion: (() -> Void)?) {
        let okAction = UIAlertAction(title: "alert_ok".localized(), style: .default) { _ in
            completion?()
        }
        okAction.setValue(UIColor.accentColor, forKey: "titleTextColor")
        alertController.addAction(okAction)
    }
    
}
