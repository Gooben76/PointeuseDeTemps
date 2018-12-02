//
//  FriendsDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 01/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData

class FriendsDataHelpers {

    static let getFunc = FriendsDataHelpers()
    
    func getAllFriends(userConnected: Users!) -> [Friends]? {
        if let result = userConnected.friends!.allObjects as? [Friends] {
            let sortedResult = result.sorted(by: { $0.friendLogin! < $1.friendLogin!})
            return sortedResult
        }
        return nil
    }
    
    func setNewFriend(login: String, mail: String, firstName: String?, lastName: String?, id: Int32, userConnected: Users) -> Bool {
        if id != 0 {
            let elm = searchFriendByFriendId(id: id, userConnected: userConnected)
            guard elm == nil else {return false}
            let newElm = Friends(context: context)
            newElm.friendId = id
            newElm.friendLogin = login
            newElm.friendMail = mail
            if firstName != nil {
                newElm.friendFirstName = firstName
            }
            if lastName != nil {
                newElm.friendLastName = lastName
            }
            newElm.active = true
            newElm.modifiedDate = Date()
            newElm.userId = userConnected
            appDelegate.saveContext()
            
            if userConnected.synchronization {
                APIFriends.getFunc.createToAPI(friendId: newElm, token: "") { (newAPI) in
                    if newAPI != nil, newAPI!.id != -1 {
                        newElm.id = Int32(newAPI!.id)
                        newElm.modifiedDate = Date()
                        appDelegate.saveContext()
                    }
                }
            }
            
            return true
        } else {
            return false
        }
    }
    
    func setFriend(friend: Friends!, userConnected: Users!) -> Bool {
        if friend != nil {
            let elm = searchFriendByFriendId(id: friend.friendId, userConnected: userConnected)
            guard elm != nil else {return false}
            elm!.setValue(friend.friendLogin, forKey: "friendLogin")
            elm!.setValue(friend.friendMail, forKey: "friendMail")
            elm!.setValue(friend.friendFirstName, forKey: "friendFirstName")
            elm!.setValue(friend.friendLastName, forKey: "friendLastName")
            elm!.setValue(friend.active, forKey: "active")
            elm!.setValue(Date(), forKey: "modifiedDate")
            do {
                try context.save()
                
                if userConnected.synchronization {
                    APIFriends.getFunc.updateToAPI(friendId: elm!, token: "", completion: { (httpcode) in
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
    
    func setNewFriendFromFriendAPI(friendAPI: FriendAPI!, userConnected: Users) -> Bool {
        if friendAPI.id != 0 {
            let newElm = Friends(context: context)
            newElm.id = Int32(friendAPI.id)
            newElm.friendId = Int32(friendAPI.friendId)
            newElm.friendLogin = friendAPI.friendLogin
            newElm.friendMail = friendAPI.friendMail
            if friendAPI.friendFirstName != "" {
                newElm.friendFirstName = friendAPI.friendFirstName
            }
            if friendAPI.friendLastName != "" {
                newElm.friendLastName = friendAPI.friendLastName
            }
            newElm.active = friendAPI.active
            newElm.modifiedDate = friendAPI.modifiedDate
            newElm.userId = userConnected
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
    }
    
    func delFriend(friend: Friends!, userConnected: Users) -> Bool {
        if friend != nil {
            let deleteId = friend.id
            context.delete(friend)
            do {
                try context.save()
                
                if userConnected.synchronization {
                    APIFriends.getFunc.deleteToAPI(id: deleteId, token: "") { (httpcode) in
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
    
    func searchFriendByFriendId(id : Int32, userConnected: Users!) -> Friends? {
        if let result = userConnected.friends?.allObjects as? [Friends] {
            let predicate1 = NSPredicate(format: "friendId = \(id)")
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [Friends] {
                if resultNS.count > 0 {
                    let sortedResult = resultNS.sorted(by: { $0.friendLogin! < $1.friendLogin!})
                    return sortedResult[0]
                }
            }
        }
        return nil
    }

    func searchFriendById(id: Int, userConnected: Users!) -> Friends? {
        if let result = userConnected.friends?.allObjects as? [Friends] {
            let predicate1 = NSPredicate(format: "id == \(id)")
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [Friends] {
                if resultNS.count > 0 {
                    let sortedResult = resultNS.sorted(by: { $0.friendLogin! < $1.friendLogin!})
                    return sortedResult[0]
                }
            }
        }
        return nil
    }
}
