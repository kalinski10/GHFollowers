//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 07/12/2020.
//

//import Foundation
//
//
//extension String {
//    
//    func convertToDate() -> Date? { // common extension for date formatting
//        let dateFormatter           = DateFormatter()
//        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"  // takes in the date format from the server
//        dateFormatter.locale        = Locale(identifier: "en_GB") // use the locale of current location
//        dateFormatter.timeZone      = .current
//        
//        return dateFormatter.date(from: self) // returns the String thats been inputed into a date format
//    }
//    
//    func convertToDisplayFormat() -> String { // secondary func that ties it all together
//        guard let date = self.convertToDate() else { return "N/A" } // converting the string to date
//        return date.convertToMonthYearFormat() // return converting the date to String
//    }
//}
