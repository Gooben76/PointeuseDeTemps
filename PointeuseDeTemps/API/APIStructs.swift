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
        self.id = dictionary["id"] as? Int ?? -1
        self.login = dictionary["login"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.mail = dictionary["mail"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.synchronization = dictionary["synchronization"] as? Bool ?? false
        self.allowMessages = dictionary["allowMessages"] as? Bool ?? false
        self.modifiedDate = dictionary["modifiedDate"] as? Date ?? Date(timeIntervalSince1970: 0)
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
        self.id = dictionary["id"] as? Int ?? -1
        self.userId = dictionary["userId"] as? Int ?? 0
        self.activityName = dictionary["activityName"] as? String ?? ""
        self.order = dictionary["order"] as? Int ?? 0
        self.gpsPosition = dictionary["gpsPosition"] as? Bool ?? false
        self.modifiedDate = dictionary["modifiedDate"] as? Date ?? Date(timeIntervalSince1970: 0)
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
        self.id = dictionary["id"] as? Int ?? -1
        self.userId = dictionary["userId"] as? Int ?? 0
        self.typicalDayName = dictionary["typicalDayName"] as? String ?? ""
        self.modifiedDate = dictionary["modifiedDate"] as? Date ?? Date(timeIntervalSince1970: 0)
    }
    
    init(typicalDayId: TypicalDays) {
        self.id = Int(typicalDayId.id)
        self.userId = Int(typicalDayId.userID!.id)
        self.typicalDayName = typicalDayId.typicalDayName!
        self.modifiedDate = typicalDayId.modifiedDate!
    }
}
