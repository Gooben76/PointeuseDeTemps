//
//  DateHelper.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 2/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let getFunc = DateHelper()
    
    func convertStringDateToDate(_ string: String) -> Date? {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        if let date = format.date(from: string) {
            return date
        } else {
            return nil
        }
    }
    
    func convertStringDateTimeToDate(_ string: String) -> Date? {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy HH:mm:ss"
        if let date = format.date(from: string) {
            return date
        } else {
            return nil
        }
    }
}
