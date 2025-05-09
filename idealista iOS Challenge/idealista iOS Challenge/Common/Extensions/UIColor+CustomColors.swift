//
//  UIColor+CustomColors.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 05/05/2025.
//

import UIKit
import SwiftUI

extension UIColor {
    
    static var primaryColor: UIColor {
        UIColor(named: "primaryColor") ?? UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1) // #2E8B57
    }
    
    static var secondaryColor: UIColor {
        UIColor(named: "secondaryColor") ?? UIColor(red: 23/255, green: 94/255, blue: 58/255, alpha: 1) // #175E3A
    }
    
    static var accentColor: UIColor {
        UIColor(named: "accentColor") ?? UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1) // #E67E22
    }
    
    static var backgroundColor: UIColor {
        UIColor(named: "backgroundColor") ?? UIColor(red: 245/255, green: 247/255, blue: 246/255, alpha: 1) // #F5F7F6
    }
    
    static var primaryTextColor: UIColor {
        UIColor(named: "primaryTextColor") ?? UIColor(red: 40/255, green: 46/255, blue: 41/255, alpha: 1) // #282E29
    }
    
    static var secondaryTextColor: UIColor {
        UIColor(named: "secondaryTextColor") ?? UIColor(red: 93/255, green: 109/255, blue: 97/255, alpha: 1) // #5D6D61
    }
    
    static var navigationColor: UIColor {
        UIColor(named: "navigationColor") ?? UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1) // #D68910
    }
    
    static var cellBackgroundColor: UIColor {
        UIColor(named: "cellBackgroundColor") ?? UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1) // #FFFFFF
    }
    
}

extension Color {
    
    static let primaryColor = Color("primaryColor")
    static let secondaryColor = Color("secondaryColor")
    static let accentAppColor = Color("accentColor")
    static let backgroundColor = Color("backgroundColor")
    
    static let primaryTextColor = Color("primaryTextColor")
    static let secondaryTextColor = Color("secondaryTextColor")
    
    static let navigationColor = Color("navigationColor")
    static let cellBackgroundColor = Color("cellBackgroundColor")
    
}
