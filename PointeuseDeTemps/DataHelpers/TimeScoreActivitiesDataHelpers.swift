//
//  TimeScoreActivitiesDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 23/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData

class TimeScoreActivitiesDataHelpers {
    
    static let getFunc = TimeScoreActivitiesDataHelpers()
    
    func getTimeScoreActivitiesForATimeScore(timeScore: TimeScores, userConnected: Users) -> [TimeScoreActivities]? {
        if let result = userConnected.timeScoresActivities?.allObjects as? [TimeScoreActivities] {
            let predicate1 = NSPredicate(format: "timeScoreId == %@", timeScore)
            if let filterResult = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivities] {
                if filterResult.count > 0 {
                    return filterResult
                }
            }
        }
        return nil
    }
    
    func setNewTimeScoreActivity(timeScore: TimeScores, activity: Activities, userConnected: Users) -> Bool {
        let elm = searchTimeScoreActivityByTimeScoreAndActivity(timeScore: timeScore, activity: activity, userConnected: userConnected)
        guard elm == nil else {return false}
        let newData = TimeScoreActivities(context: context)
        newData.timeScoreId = timeScore
        newData.activityId = activity
        newData.running = false
        newData.userId = userConnected
        newData.modifiedDate = Date()
        appDelegate.saveContext()
        return true
    }
    
    func setTimeScoreActivity(timeScoreActivity: TimeScoreActivities, userConnected: Users!) -> Bool {
        let elm = searchTimeScoreActivityByTimeScoreAndActivity(timeScore: timeScoreActivity.timeScoreId!, activity: timeScoreActivity.activityId!, userConnected: userConnected)
        guard elm != nil else {return false}
        elm!.setValue(timeScoreActivity.running, forKey: "running")
        elm!.setValue(Date(), forKey: "modifiedDate")
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func setTimeScoreActivityRunning(timeScoreActivity: TimeScoreActivities, running: Bool, userConnected: Users!) -> Bool {
        let elm = searchTimeScoreActivityByTimeScoreAndActivity(timeScore: timeScoreActivity.timeScoreId!, activity: timeScoreActivity.activityId!, userConnected: userConnected)
        guard elm != nil else {return false}
        if running {
            if !TimeScoreActivityDetailsDataHelpers.getFunc.setNewTimeScoreActivityDetail(timeScoreActivity: timeScoreActivity, userConnected: userConnected) {
                print("Erreur de sauvegarde TimeScoreActivityDetail")
            }
        } else {
            if !TimeScoreActivityDetailsDataHelpers.getFunc.updateTimeScoreActivityDetail(timeScoreActivity: timeScoreActivity, userConnected: userConnected) {
                print("Erreur de sauvegarde TimeScoreActivityDetail")
            }
        }
        elm!.setValue(running, forKey: "running")
        elm!.setValue(Date(), forKey: "modifiedDate")
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func searchTimeScoreActivityByTimeScoreAndActivity(timeScore: TimeScores, activity: Activities, userConnected: Users!) -> TimeScoreActivities? {
        if let result = userConnected.timeScoresActivities?.allObjects as? [TimeScoreActivities] {
            let predicate1 = NSPredicate(format: "timeScoreId == %@ AND activityId == %@", timeScore, activity)
            if let filterResult = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivities] {
                if filterResult.count > 0 {
                    return filterResult[0]
                }
            }
        }
        return nil
    }
    
    func delTimeScoreActivity(timeScoreActivity: TimeScoreActivities!) -> Bool {
        if timeScoreActivity != nil {
            context.delete(timeScoreActivity)
            do {
                try context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
}
