//
//  Coordinator.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}
