//
//  AlertService.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 08/05/2025.
//

import UIKit

@MainActor
class AlertService {
    func showOfflineAlert(on viewController: UIViewController, completion: @escaping () -> Void) {
        AlertHelper.showOfflineAlert(on: viewController, completion: completion)
    }
    
    func showErrorAlert(error: Error, on viewController: UIViewController) {
        AlertHelper.showCriticalErrorAlert(on: viewController)
    }
}
