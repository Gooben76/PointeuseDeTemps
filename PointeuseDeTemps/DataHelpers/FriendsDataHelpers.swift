//
//  FriendsDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 14/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

class FriendsDataHelpers {
    
    static let getFunc = FriendsDataHelpers()
    
    func getAllFriendsFromMessages(userConnected: Users) -> [Friends]? {
        let allMessages = MessagesDataHelpers.getFunc.getAllMessages(userConnected: userConnected)
        var friends: [Friends] = [Friends]()
        if allMessages != nil {
            for msg: Messages in allMessages! {
                if msg.userFromId != userConnected {
                    if !friends.contains(where: {$0.user == msg.userFromId!}) {
                        friends.append(Friends(user: msg.userFromId!, active: msg.userFromId!.allowMessages))
                    }
                } else if msg.userToId != userConnected {
                    if !friends.contains(where: {$0.user == msg.userToId!}) {
                        friends.append(Friends(user: msg.userToId!, active: msg.userFromId!.allowMessages))
                    }
                }
            }
            return friends
        }
        return nil
    }
    
    func deleteAllMessagesFromAndToAFriend(friend: Friends, userConnected: Users) -> Bool {
        
        return true
    }
}
