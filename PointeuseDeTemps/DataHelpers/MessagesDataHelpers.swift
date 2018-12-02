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
        if let result = userConnected.messages!.allObjects as? [Messages] {
            let sortedResult = result.sorted(by: { $0.modifiedDate! < $1.modifiedDate!})
            return sortedResult
        }
        return nil
    }
    
    func setNewMessage(friendId: Friends, fromMe: Bool, message: String, sms: Bool, userConnected: Users) -> Bool {
        if message.count > 0 {
            let newElm = Messages(context: context)
            newElm.friendId = friendId
            newElm.fromMe = fromMe
            newElm.sms = sms
            newElm.message! = message
            newElm.read = false
            newElm.modifiedDate = Date()
            newElm.userId = userConnected
            appDelegate.saveContext()
            
            if userConnected.synchronization {
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
            newElm.friendId = FriendsDataHelpers.getFunc.searchFriendById(id: messageAPI.friendId, userConnected: userConnected)
            newElm.fromMe = messageAPI.fromMe
            newElm.sms = messageAPI.sms
            newElm.read = messageAPI.read
            newElm.message = messageAPI.message
            newElm.modifiedDate = messageAPI.modifiedDate
            newElm.userId = userConnected
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
    }
    
    func delMessage(message: Messages!, userConnected: Users) -> Bool {
        if message != nil {
            let deleteId = message.id
            context.delete(message)
            do {
                try context.save()
                
                if userConnected.synchronization {
                    APIMessages.getFunc.deleteToAPI(id: deleteId, token: "") { (httpcode) in
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
    
    func searchMessageById(id: Int, userConnected: Users!) -> Messages? {
        if let result = userConnected.messages?.allObjects as? [Messages] {
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
}
