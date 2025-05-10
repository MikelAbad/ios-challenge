//
//  UITestingHelper.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 10/05/2025.
//

import Foundation

enum TestingLaunchArguments {
    static let uiTesting = "--uitesting"
}

extension ProcessInfo {
    static var isRunningUITests: Bool {
        ProcessInfo.processInfo.arguments.contains(TestingLaunchArguments.uiTesting)
    }
}
