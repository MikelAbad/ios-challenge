//
//  Date+Format.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 05/05/2025.
//

import Foundation

extension Date {
    
    func relativeFormat() -> String {
        if Calendar.current.isDateInToday(self) {
            return "date_today".localized()
        }
        
        if Calendar.current.isDateInYesterday(self) {
            return "date_yesterday".localized()
        }
        
        let days = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
        if days > 0 && days < 10  {
            return String(format: "date_days_ago".localized(), days)
        }
        
        return shortFormat()
    }
    
    func shortFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self)
    }
    
}
