//
//  String+Localizable.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 30/04/2025.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }
}
