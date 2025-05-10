//
//  SplashViewController.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SplashViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibilityIdentifiers()
        
        #if DEBUG
        if ProcessInfo.isRunningUITests {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                Task {
                    await self.viewModel.loadData()
                }
            }
            return
        }
        #endif
        
        Task {
            await viewModel.loadData()
        }
    }
    
}

private extension SplashViewController {
    
    func setupAccessibilityIdentifiers() {
        logoImageView.accessibilityIdentifier = AccessibilityIdentifiers.SplashScreen.logoImage
        activityIndicator.accessibilityIdentifier = AccessibilityIdentifiers.SplashScreen.activityIndicator
    }
    
}
