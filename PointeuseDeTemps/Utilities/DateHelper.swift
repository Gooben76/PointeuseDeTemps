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
    
    func convertDateToString(_ date: Date) -> String? {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let data = format.string(from: date)
        return data
    }
    
    func convertDateTimeToString(_ date: Date) -> String? {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let data = format.string(from: date)
        return data
    }
    
    func convertDateTimeToDouble(_ date: Date) -> Double {
        return date.timeIntervalSince1970
    }
    
    func getDurationBetween2Dates(startDate: Date, endDate: Date) -> Double {
        let startDouble: Double = convertDateTimeToDouble(startDate)
        let endDouble: Double = convertDateTimeToDouble(endDate)
        let duration: Double = endDouble - startDouble
        return duration
    }
    
    func getDurationBetween2Dates(startDate: Date, endDate: Date) -> String {
        let durationComponents: DateComponents = Calendar.current.dateComponents([.hour, .minute , .second], from: startDate, to: endDate)
        var data: String = ""
        if let hours = durationComponents.hour, hours > 0 {
            data += String(hours) + " " + RSC_HOURS
        }
        if let minutes = durationComponents.minute, minutes > 0 {
            data += String(minutes) + " " + RSC_MINUTES
        }
        if let seconds = durationComponents.second, seconds > 0 {
            data += String(seconds) + " " + RSC_SECONDS
        }
        return data
    }
    
    func getDurationFromDouble(duration: Double) -> String {
        let date = Date.init(timeIntervalSince1970: duration)
        let dateStart = Date.init(timeIntervalSince1970: 0)
        return getDurationBetween2Dates(startDate: dateStart, endDate: date)
    }
}
