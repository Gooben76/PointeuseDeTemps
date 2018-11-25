//
//  APIStructs.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 01/11/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

struct Token {
    var token: String
    var id: Int
    
    init(token: String, id: Int) {
        self.token = token
        self.id = id
    }
}

struct ResponseToken: Codable {
    var login: String
    var mail : String
    var id: Int
    var token: String
    
    init(_ dictionary: [String: Any]) {
        self.login = dictionary["login"] as? String ?? ""
        self.mail = dictionary["mail"] as? String ?? ""
        self.id = dictionary["id"] as? Int ?? -1
        self.token = dictionary["token"] as? String ?? ""
    }
}

struct UserAPI: Codable {
    var id: Int
    var login: String
    var password: String
    var mail: String
    var firstName: String
    var lastName: String
    var synchronization: Bool
    var allowMessages: Bool
    var modifiedDate: Date
    
    init(_ dictionary: [String: Any]) {
        let modifiedDateAny = dictionary["modifiedDate"]
        let modifiedDateString: String = String(describing: modifiedDateAny!)
        var modifiedDate: Date? = nil
        if modifiedDateString != "<null>" {
            modifiedDate = DateHelper.getFunc.convertStringDateTimeJsonToDate(modifiedDateString)!
        }
        
        self.id = dictionary["id"] as? Int ?? -1
        self.login = dictionary["login"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.mail = dictionary["mail"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.synchronization = dictionary["synchronization"] as? Bool ?? false
        self.allowMessages = dictionary["allowMessages"] as? Bool ?? false
        self.modifiedDate = modifiedDate!
    }
    
    init(userId: Users) {
        self.id = Int(userId.id)
        self.login = userId.login!
        self.password = userId.password!
        self.mail = userId.mail!
        self.firstName = userId.firstName ?? ""
        self.lastName = userId.lastName ?? ""
        self.synchronization = userId.synchronization
        self.allowMessages  = userId.allowMessages
        self.modifiedDate = userId.modifiedDate!
    }
}

struct ActivityAPI: Codable {
    var id: Int
    var userId: Int
    var activityName: String
    var order: Int
    var gpsPosition: Bool
    var modifiedDate: Date
    
    init(_ dictionary: [String: Any]) {
        let modifiedDateAny = dictionary["modifiedDate"]
        let modifiedDateString: String = String(describing: modifiedDateAny!)
        var modifiedDate: Date? = nil
        if modifiedDateString != "<null>" {
            modifiedDate = DateHelper.getFunc.convertStringDateTimeJsonToDate(modifiedDateString)!
        }
        
        self.id = dictionary["id"] as? Int ?? -1
        self.userId = dictionary["userId"] as? Int ?? 0
        self.activityName = dictionary["activityName"] as? String ?? ""
        self.order = dictionary["order"] as? Int ?? 0
        self.gpsPosition = dictionary["gpsPosition"] as? Bool ?? false
        self.modifiedDate = modifiedDate!
    }
    
    init(activityId: Activities) {
        self.id = Int(activityId.id)
        self.userId = Int(activityId.userID!.id)
        self.activityName = activityId.activityName!
        self.order = Int(activityId.order)
        self.gpsPosition = activityId.gpsPosition
        self.modifiedDate = activityId.modifiedDate!
    }
}

struct TypicalDayAPI: Codable {
    var id: Int
    var userId: Int
    var typicalDayName: String
    var modifiedDate: Date
    
    init(_ dictionary: [String: Any]) {
        let modifiedDateAny = dictionary["modifiedDate"]
        let modifiedDateString: String = String(describing: modifiedDateAny!)
        var modifiedDate: Date? = nil
        if modifiedDateString != "<null>" {
            modifiedDate = DateHelper.getFunc.convertStringDateTimeJsonToDate(modifiedDateString)!
        }
        
        self.id = dictionary["id"] as? Int ?? -1
        self.userId = dictionary["userId"] as? Int ?? 0
        self.typicalDayName = dictionary["typicalDayName"] as? String ?? ""
        self.modifiedDate = modifiedDate!
    }
    
    init(typicalDayId: TypicalDays) {
        self.id = Int(typicalDayId.id)
        self.userId = Int(typicalDayId.userID!.id)
        self.typicalDayName = typicalDayId.typicalDayName!
        self.modifiedDate = typicalDayId.modifiedDate!
    }
}

struct TypicalDayActivityAPI: Codable {
    var id: Int
    var userId: Int
    var typicalDayId: Int
    var activityId: Int
    var modifiedDate: Date
    
    init(_ dictionary: [String: Any]) {
        let modifiedDateAny = dictionary["modifiedDate"]
        let modifiedDateString: String = String(describing: modifiedDateAny!)
        var modifiedDate: Date? = nil
        if modifiedDateString != "<null>" {
            modifiedDate = DateHelper.getFunc.convertStringDateTimeJsonToDate(modifiedDateString)!
        }
        
        self.id = dictionary["id"] as? Int ?? -1
        self.userId = dictionary["userId"] as? Int ?? 0
        self.typicalDayId = dictionary["typicalDayId"] as? Int ?? 0
        self.activityId = dictionary["activityId"] as? Int ?? 0
        self.modifiedDate = modifiedDate!
    }
    
    init(typicalDayActivityId: TypicalDayActivities) {
        self.id = Int(typicalDayActivityId.id)
        self.userId = Int(typicalDayActivityId.userId!.id)
        self.typicalDayId = Int(typicalDayActivityId.typicalDayId!.id)
        self.activityId = Int(typicalDayActivityId.activityId!.id)
        self.modifiedDate = typicalDayActivityId.modifiedDate!
    }
}

struct TimeScoreAPI: Codable {
    var id: Int
    var userId: Int
    var date: Date
    var typicalDayId: Int?
    var modifiedDate: Date
    
    init(_ dictionary: [String: Any]) {
        let dateAny = dictionary["date"]
        let dateString: String = String(describing: dateAny!)
        let date: Date = DateHelper.getFunc.convertStringDateTimeJsonToDate(dateString)!
        
        let modifiedDateAny = dictionary["modifiedDate"]
        let modifiedDateString: String = String(describing: modifiedDateAny!)
        var modifiedDate: Date? = nil
        if modifiedDateString != "<null>" {
            modifiedDate = DateHelper.getFunc.convertStringDateTimeJsonToDate(modifiedDateString)!
        }
        
        self.id = dictionary["id"] as? Int ?? -1
        self.userId = dictionary["userId"] as? Int ?? 0
        self.date = date
        self.typicalDayId = dictionary["typicalDayId"] as? Int ?? 0
        self.modifiedDate = modifiedDate!
    }
    
    init(timeScoreId: TimeScores) {
        self.id = Int(timeScoreId.id)
        self.userId = Int(timeScoreId.userId!.id)
        if timeScoreId.typicalDayId != nil {
            self.typicalDayId = Int(timeScoreId.typicalDayId!.id)
        }
        self.date = timeScoreId.date!
        self.modifiedDate = timeScoreId.modifiedDate!
    }
}

struct TimeScoreActivityAPI: Codable {
    var id: Int
    var userId: Int
    var timeScoreId: Int
    var activityId: Int
    var running: Bool
    var modifiedDate: Date
    
    init(_ dictionary: [String: Any]) {
        let modifiedDateAny = dictionary["modifiedDate"]
        let modifiedDateString: String = String(describing: modifiedDateAny!)
        var modifiedDate: Date? = nil
        if modifiedDateString != "<null>" {
            modifiedDate = DateHelper.getFunc.convertStringDateTimeJsonToDate(modifiedDateString)!
        }
        
        self.id = dictionary["id"] as? Int ?? -1
        self.userId = dictionary["userId"] as? Int ?? 0
        self.timeScoreId = dictionary["timeScoreId"] as? Int ?? 0
        self.activityId = dictionary["activityId"] as? Int ?? 0
        self.running = dictionary["running"] as? Bool ?? false
        self.modifiedDate = modifiedDate!
    }
    
    init(timeScoreActivityId: TimeScoreActivities) {
        self.id = Int(timeScoreActivityId.id)
        self.userId = Int(timeScoreActivityId.userId!.id)
        self.timeScoreId = Int(timeScoreActivityId.timeScoreId!.id)
        self.activityId = Int(timeScoreActivityId.activityId!.id)
        self.running = timeScoreActivityId.running
        self.modifiedDate = timeScoreActivityId.modifiedDate!
    }
}

struct TimeScoreActivityDetailAPI: Codable {
    var id: Int
    var userId: Int
    var timeScoreActivityId: Int
    var running: Bool
    var duration: Double
    var startDateTime: Date
    var endDateTime: Date?
    var startLatitude: Double
    var startLongitude: Double
    var endLatitude: Double
    var endLongitude: Double
    var modifiedDate: Date
    
    init(_ dictionary: [String: Any]) {
        let modifiedDateAny = dictionary["modifiedDate"]
        let modifiedDateString: String = String(describing: modifiedDateAny!)
        var modifiedDate: Date? = nil
        if modifiedDateString != "<null>" {
            modifiedDate = DateHelper.getFunc.convertStringDateTimeJsonToDate(modifiedDateString)!
        }
        
        let startDateAny = dictionary["startDateTime"]
        let startDateString: String = String(describing: startDateAny!)
        let startDate: Date = DateHelper.getFunc.convertStringDateTimeJsonToDate(startDateString)!
        
        let endDateAny = dictionary["endDateTime"]
        let endDateString: String = String(describing: endDateAny!)
        var endDate: Date? = nil
        if endDateString != "<null>" {
            endDate = DateHelper.getFunc.convertStringDateTimeJsonToDate(endDateString)!
        }
        
        self.id = dictionary["id"] as? Int ?? -1
        self.userId = dictionary["userId"] as? Int ?? 0
        self.timeScoreActivityId = dictionary["timeScoreActivityId"] as? Int ?? 0
        self.running = dictionary["running"] as? Bool ?? false
        self.duration = dictionary["duration"] as? Double ?? 0
        self.startDateTime = startDate
        self.endDateTime = endDate
        self.startLatitude = dictionary["startLatitude"] as? Double ?? 0
        self.startLongitude = dictionary["startLongitude"] as? Double ?? 0
        self.endLatitude = dictionary["endLatitude"] as? Double ?? 0
        self.endLongitude = dictionary["endLongitude"] as? Double ?? 0
        self.modifiedDate = modifiedDate!
    }
    
    init(timeScoreActivityDetailId: TimeScoreActivityDetails) {
        self.id = Int(timeScoreActivityDetailId.id)
        self.userId = Int(timeScoreActivityDetailId.userId!.id)
        self.timeScoreActivityId = Int(timeScoreActivityDetailId.timeScoreActivityId!.id)
        self.running = timeScoreActivityDetailId.running
        self.duration = timeScoreActivityDetailId.duration
        self.startDateTime = timeScoreActivityDetailId.startDateTime!
        if timeScoreActivityDetailId.endDateTime != nil {
            self.endDateTime = timeScoreActivityDetailId.endDateTime!
        } else {
            self.endDateTime = Date.init(timeIntervalSince1970: 0)
        }
        self.startLatitude = timeScoreActivityDetailId.startLatitude
        self.startLongitude = timeScoreActivityDetailId.startLongitude
        self.endLatitude = timeScoreActivityDetailId.endLatitude
        self.endLongitude = timeScoreActivityDetailId.endLongitude
        self.modifiedDate = timeScoreActivityDetailId.modifiedDate!
    }
}
