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
        
        /*if self.password.count > 0 {
            self.password = EncodeHelpers.getFunc.decrypte(key: self.password)
        }
        */
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
