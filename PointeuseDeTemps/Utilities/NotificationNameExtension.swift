//
//  NotificationNameExtension.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 23/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

extension Notification.Name {
    
    static let numberActivitiesInTypicalDay = Notification.Name(rawValue: "numberActivitiesInTypicalDay")
    static let changeRunningStatusInTimeScoreActivity = Notification.Name(rawValue: "changeRunningStatusInTimeScoreActivity")
    static let showErrorMessageInActivitiesController = Notification.Name(rawValue: "showErrorMessageInActivitiesController")
    static let refreshActivitiesController = Notification.Name(rawValue: "refreshActivitiesController")
    static let loadFriendsUsers = Notification.Name(rawValue: "loadFriendsUsers")
    static let newMessageForAFriendMessage = Notification.Name(rawValue: "newMessageForAFriendMessage")
    static let newMessageForAFriendFriend = Notification.Name(rawValue: "newMessageForAFriendFriend")
}
