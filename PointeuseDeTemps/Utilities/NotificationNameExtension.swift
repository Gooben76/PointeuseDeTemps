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
}
