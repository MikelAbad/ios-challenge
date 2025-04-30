//
//  SplashViewController.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import UIKit

class SplashViewController: UIViewController {
    
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
        
        Task {
            await viewModel.loadData()
        }
    }
    
}
