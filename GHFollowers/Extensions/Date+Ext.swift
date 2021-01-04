//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 07/12/2020.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "MMM yyyy" // the format we want to pass back
        return dateFormatter.string(from: self) // return the date into String
    }
    
}
