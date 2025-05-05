//
//  AppearanceHelper.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 05/05/2025.
//

import UIKit

class AppearanceHelper {
    
    static func configure() {
        configureNavigationBar()
    }
    
}

private extension AppearanceHelper {
    
    static func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navigationColor
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.primaryTextColor,
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.accentColor
    }
    
}
