//
//  UsersDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 1/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData

class UsersDataHelpers {
    
    static let getFunc = UsersDataHelpers()
    
    func getAllUsers() -> [Users] {
        var users = [Users]()
        let query: NSFetchRequest<Users> = Users.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "login", ascending: true)
        query.sortDescriptors?.append(sortDescriptor)
        do {
            users = try context.fetch(query)
        } catch {
            print(error.localizedDescription)
        }
        return users
    }
    
    func setNewUser(login: String, password: String, firstName: String?, lastName: String?, mail: String?, image: UIImage?, synchronization: Bool, allowMessages: Bool) -> Bool {
        if login != "" && password != "" {
            let elm = searchUserByLogin(login: login)
            guard elm == nil else {return false}
            let newUser = Users(context: context)
            newUser.login = login
            newUser.password = password
            if firstName != "" {
                newUser.firstName = firstName
            }
            if lastName != "" {
                newUser.lastName = lastName
            }
            if mail != "" {
                newUser.mail = mail
            }
            if image != nil {
                newUser.image = image
            }
            newUser.synchronization = synchronization
            newUser.allowMessages = allowMessages
            newUser.modifiedDate = Date()
            appDelegate.saveContext()
            
            if newUser.synchronization {
                APIUsers.getFunc.createUserToAPI(userId: newUser, token: "", completion: { (apiUser) in
                    if apiUser != nil, apiUser!.id != -1 {
                        newUser.id = Int32(apiUser!.id)
                        newUser.modifiedDate = Date()
                        appDelegate.saveContext()
                    }
                })
            }
            return true
        } else {
            return false
        }
    }
    
    func delUser(user: Users!) -> Bool {
        if user != nil {
            let synchro: Bool = user.synchronization
            let deleteId = user.id
            context.delete(user)
            do {
                try context.save()
                
                if synchro {
                    APIUsers.getFunc.deleteUserToAPI(userId: deleteId, token: "") { (httpcode) in
                        print("http response code : \(httpcode)")
                    }
                }
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    func setUser(user: Users!) -> Bool {
        if user != nil {
            let elm = searchUserByLogin(login: user.login!)
            guard elm != nil else {return false}
            elm!.setValue(user.password, forKey: "password")
            elm!.setValue(user.firstName, forKey: "firstName")
            elm!.setValue(user.lastName, forKey: "lastName")
            elm!.setValue(user.mail, forKey: "mail")
            elm!.setValue(user.image, forKey: "image")
            elm!.setValue(Date(), forKey: "modifiedDate")
            do {
                try context.save()
                
                if user.synchronization {
                    APIUsers.getFunc.updateUserToAPI(userId: user, token: "", completion: { (httpcode) in
                        print("http response code : \(httpcode)")
                    })
                }
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    func searchUserByLogin(login : String) -> Users? {
        let query: NSFetchRequest<Users> = Users.fetchRequest()
        query.predicate = NSPredicate(format: "login like %@", login)
        do {
            var foundRecordsArray = [Users]()
            try foundRecordsArray = context.fetch(query)
            if foundRecordsArray.count > 0 {
                return foundRecordsArray[0]
            } else {
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
