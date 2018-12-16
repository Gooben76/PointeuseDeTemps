//
//  MessagesDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 02/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData

class MessagesDataHelpers {

    static let getFunc = MessagesDataHelpers()
    
    func getAllMessages(userConnected: Users!) -> [Messages]? {
        if let resultFrom = userConnected.messagesFrom?.allObjects as? [Messages] {
            if let resultTo = userConnected.messagesTo?.allObjects as? [Messages] {
                var result = [Messages]()
                result.append(contentsOf: resultFrom)
                result.append(contentsOf: resultTo)
                let sortedResult = result.sorted(by: { $0.modifiedDate! < $1.modifiedDate!})
                return sortedResult
            }
        }
        return nil
    }
    
    func getAllMessageForAUser(friend: Users!, userConnected: Users!) -> [Messages]? {
        if let result = getAllMessages(userConnected: userConnected) {
            let predicate1 = NSPredicate(format: "userFromId == %@ OR userToId == %@", friend, friend)
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [Messages] {
                if resultNS.count > 0 {
                    let sortedResult = resultNS.sorted(by: { $0.modifiedDate! < $1.modifiedDate!})
                    return sortedResult
                }
            }
        }
        return nil
    }
    
    func setNewMessage(userFromId: Users, userToId: Users, message: String, sms: Bool, userConnected: Users, withoutSynchronization: Bool = false) -> Bool {
        if message.count > 0 {
            let newElm = Messages(context: context)
            newElm.userFromId = userFromId
            newElm.userToId = userToId
            newElm.sms = sms
            newElm.message = message
            newElm.read = false
            newElm.modifiedDate = Date()
            appDelegate.saveContext()
            
            if userConnected.synchronization && !withoutSynchronization {
                APIMessages.getFunc.createToAPI(messageId: newElm, token: "") { (newAPI) in
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
    
    func setNewMessageFromMessageAPI(messageAPI: MessageAPI!, userConnected: Users) -> Bool {
        if messageAPI.id != 0 {
            let newElm = Messages(context: context)
            newElm.id = Int32(messageAPI.id)
            newElm.userFromId = UsersDataHelpers.getFunc.searchUserById(id: Int32(messageAPI.userFromId))
            newElm.userToId = UsersDataHelpers.getFunc.searchUserById(id: Int32(messageAPI.userToId))
            newElm.sms = messageAPI.sms
            newElm.read = messageAPI.read
            newElm.message = messageAPI.message
            newElm.modifiedDate = messageAPI.modifiedDate
            appDelegate.saveContext()
            
            NotificationCenter.default.post(name: .newMessageForAFriendMessage, object: nil)
            NotificationCenter.default.post(name: .newMessageForAFriendFriend, object: nil)
            
            return true
        } else {
            return false
        }
    }
    
    func setMessage(message: Messages!, userConnected: Users!, withoutSynchronization: Bool = false) -> Bool {
        if message != nil {
            let elm = searchMessageByUserFromIdAndUserToIdAndDate(userFromId: message.userFromId!, userToId: message.userToId!, date: message.modifiedDate!, userConnected: userConnected)
            guard elm != nil else {return false}
            elm!.setValue(message.id, forKey: "id")
            elm!.setValue(message.userFromId, forKey: "userFromId")
            elm!.setValue(message.userToId, forKey: "userToId")
            elm!.setValue(message.sms, forKey: "sms")
            elm!.setValue(message.read, forKey: "read")
            elm!.setValue(message.message, forKey: "message")
            elm!.setValue(message.modifiedDate, forKey: "modifiedDate")
            do {
                try context.save()
                
                if userConnected.synchronization && !withoutSynchronization {
                    APIMessages.getFunc.updateToAPI(messageId: elm!, token: "", completion: { (httpcode) in
                        //
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
    
    func delMessage(message: Messages!, userConnected: Users, withoutSynchronization: Bool = false) -> Bool {
        if message != nil {
            let deleteId = message.id
            context.delete(message)
            do {
                try context.save()
                
                if userConnected.synchronization && !withoutSynchronization {
                    APIMessages.getFunc.deleteToAPI(id: deleteId, token: "") { (httpcode) in
                     //
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
    
    func searchMessageById(id: Int, userConnected: Users!) -> Messages? {
        if let result = getAllMessages(userConnected: userConnected) {
            let predicate1 = NSPredicate(format: "id == \(id)")
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [Messages] {
                if resultNS.count > 0 {
                    let sortedResult = resultNS.sorted(by: { $0.modifiedDate! < $1.modifiedDate!})
                    return sortedResult[0]
                }
            }
        }
        return nil
    }
    
    func searchMessageByUserFromIdAndUserToIdAndDate(userFromId: Users, userToId: Users, date: Date, userConnected: Users!) -> Messages? {
        if let result = getAllMessages(userConnected: userConnected) {
            let predicate1 = NSPredicate(format: "userFromId == %@ AND userToId == %@ AND modifiedDate == %@", userFromId, userToId, date as CVarArg)
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [Messages] {
                if resultNS.count > 0 {
                    let sortedResult = resultNS.sorted(by: { $0.modifiedDate! < $1.modifiedDate!})
                    return sortedResult[0]
                }
            }
        }
        return nil
    }
}
