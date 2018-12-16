//
//  DoubleExtension.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 10/11/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

extension Double {
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func getVisibleDateForMessage() -> String {
        var string = RSC_THE
        let date: Date = Date(timeIntervalSince1970: self)
        let calendrier = Calendar.current
        let formatter = DateFormatter()
        if calendrier.isDateInToday(date) {
            string = ""
            formatter.timeStyle = .short
        } else if calendrier.isDateInYesterday(date) {
            string = RSC_YESTERDAY
            formatter.timeStyle = .short
        } else {
            formatter.dateStyle = .short
        }
        let dateString = formatter.string(from: date)
        return string + dateString
    }
}
