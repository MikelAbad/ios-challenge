//
//  MockViewController.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 10/05/2025.
//

import UIKit
@testable import idealista_iOS_Challenge

class MockViewController: UIViewController {
    private var _mockedPresentedViewController: UIViewController?
    var presentMethodCalled = false
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentMethodCalled = true
        _mockedPresentedViewController = viewControllerToPresent
        completion?()
    }
    
    override var presentedViewController: UIViewController? {
        _mockedPresentedViewController
    }
}
