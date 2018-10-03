//
//  TimeScoreActivityDetailsDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 3/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData

class TimeScoreActivityDetailsDataHelpers {
    
    static let getFunc = TimeScoreActivityDetailsDataHelpers()
    
    func getTimeScoreActivityDetailssForATimeScoreActivity(timeScoreActivity: TimeScoreActivities, userConnected: Users) -> [TimeScoreActivityDetails]? {
        if let result = userConnected.timeScoreActivityDetails?.allObjects as? [TimeScoreActivityDetails] {
            let predicate1 = NSPredicate(format: "timeScoreActivityId == %@", timeScoreActivity)
            if let filterResult = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivityDetails] {
                if filterResult.count > 0 {
                    return filterResult
                }
            }
        }
        return nil
    }
    
    func setNewTimeScoreActivityDetail(timeScoreActivity: TimeScoreActivities, userConnected: Users) -> Bool {
        let newData = TimeScoreActivityDetails(context: context)
        newData.timeScoreActivityId = timeScoreActivity
        newData.startDateTime = Date()
        newData.running = true
        newData.userId = userConnected
        newData.modifiedDate = Date()
        appDelegate.saveContext()
        return true
    }
    
    func updateTimeScoreActivityDetail(timeScoreActivity: TimeScoreActivities, userConnected: Users) -> Bool {
        if let result = userConnected.timeScoreActivityDetails?.allObjects as? [TimeScoreActivityDetails] {
            let predicate1 = NSPredicate(format: "timeScoreActivityId == %@ AND running == true", timeScoreActivity)
            if let filterResult = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivityDetails] {
                if filterResult.count > 0 {
                    filterResult[0].setValue(false, forKey: "running")
                    filterResult[0].setValue(Date(), forKey: "endDateTime")
                    filterResult[0].setValue(Date(), forKey: "modifiedDate")
                    do {
                        try context.save()
                        return true
                    } catch {
                        print(error.localizedDescription)
                        return false
                    }
                }
            }
        }
        return false
    }
}
