//
//  TimeScoreActivitiesDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 23/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class TimeScoreActivitiesDataHelpers {
    
    static let getFunc = TimeScoreActivitiesDataHelpers()
    
    func getAllTimeScoreActivities(userConnected: Users!) -> [TimeScoreActivities]? {
        if let result = userConnected.timeScoresActivities?.allObjects as? [TimeScoreActivities] {
            return result
        }
        return nil
    }
    
    func getTimeScoreActivitiesForATimeScore(timeScore: TimeScores, userConnected: Users) -> [TimeScoreActivities]? {
        if let result = userConnected.timeScoresActivities?.allObjects as? [TimeScoreActivities] {
            let predicate1 = NSPredicate(format: "timeScoreId == %@", timeScore)
            if let filterResult = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivities] {
                if filterResult.count > 0 {
                    let sortedResult = filterResult.sorted(by: { $0.activityId!.order < $1.activityId!.order})
                    return sortedResult
                }
            }
        }
        return nil
    }
    
    func setNewTimeScoreActivity(timeScore: TimeScores, activity: Activities, userConnected: Users, withoutSynchronization: Bool = false) -> Bool {
        let elm = searchTimeScoreActivityByTimeScoreAndActivity(timeScore: timeScore, activity: activity, userConnected: userConnected)
        guard elm == nil else {return false}
        let newElm = TimeScoreActivities(context: context)
        newElm.timeScoreId = timeScore
        newElm.activityId = activity
        newElm.running = false
        newElm.userId = userConnected
        newElm.modifiedDate = Date()
        appDelegate.saveContext()
        
        if userConnected.synchronization && !withoutSynchronization {
            APITimeScoreActivities.getFunc.createToAPI(timeScoreActivityId: newElm, token: "") { (newAPI) in
                if newAPI != nil, newAPI!.id != -1 {
                    newElm.id = Int32(newAPI!.id)
                    newElm.modifiedDate = Date()
                    appDelegate.saveContext()
                }
            }
        }
        return true
    }
    
    func setTimeScoreActivity(timeScoreActivity: TimeScoreActivities, userConnected: Users!, withoutSynchronization: Bool = false) -> Bool {
        let elm = searchTimeScoreActivityByTimeScoreAndActivity(timeScore: timeScoreActivity.timeScoreId!, activity: timeScoreActivity.activityId!, userConnected: userConnected)
        guard elm != nil else {return false}
        elm!.setValue(timeScoreActivity.running, forKey: "running")
        elm!.setValue(Date(), forKey: "modifiedDate")
        do {
            try context.save()
            
            if userConnected.synchronization && !withoutSynchronization {
                APITimeScoreActivities.getFunc.updateToAPI(timeScoreActivityId: elm!, token: "", completion: { (httpcode) in
                    //
                })
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func setTimeScoreActivityRunning(timeScoreActivity: TimeScoreActivities, running: Bool, coordinates: CLLocationCoordinate2D?, userConnected: Users!, withoutSynchronization: Bool = false) -> Bool {
        let elm = searchTimeScoreActivityByTimeScoreAndActivity(timeScore: timeScoreActivity.timeScoreId!, activity: timeScoreActivity.activityId!, userConnected: userConnected)
        guard elm != nil else {return false}
        if running {
            if !TimeScoreActivityDetailsDataHelpers.getFunc.setNewTimeScoreActivityDetail(timeScoreActivity: timeScoreActivity, coordinates: coordinates, userConnected: userConnected) {
                //
            }
        } else {
            if !TimeScoreActivityDetailsDataHelpers.getFunc.updateTimeScoreActivityDetail(timeScoreActivity: timeScoreActivity, coordinates: coordinates, userConnected: userConnected) {
                //
            }
        }
        elm!.setValue(running, forKey: "running")
        elm!.setValue(Date(), forKey: "modifiedDate")
        do {
            try context.save()
            
            if userConnected.synchronization && !withoutSynchronization {
                APITimeScoreActivities.getFunc.updateToAPI(timeScoreActivityId: elm!, token: "", completion: { (httpcode) in
                    //
                })
            }
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
    
    func delTimeScoreActivity(timeScoreActivity: TimeScoreActivities!, userConnected: Users!, withoutSynchronization: Bool = false) -> Bool {
        if timeScoreActivity != nil {
            let deleteId = timeScoreActivity.id
            context.delete(timeScoreActivity)
            do {
                try context.save()
                
                if userConnected.synchronization && !withoutSynchronization {
                    APIActivities.getFunc.deleteToAPI(id: deleteId, token: "") { (httpcode) in
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
    
    func searchTimeScoreActivityById(id: Int, userConnected: Users!) -> TimeScoreActivities? {
        if let result = userConnected.timeScoresActivities?.allObjects as? [TimeScoreActivities] {
            let predicate1 = NSPredicate(format: "id == \(id)")
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivities] {
                if resultNS.count > 0 {
                    return resultNS[0]
                }
            }
        }
        return nil
    }
    
    func setNewTimeScoreActivityFromTimeScoreActivityAPI(timeScoreActivityAPI: TimeScoreActivityAPI!, userConnected: Users) -> Bool {
        if timeScoreActivityAPI.timeScoreId > 0 && timeScoreActivityAPI.activityId > 0 {
            let newElm = TimeScoreActivities(context: context)
            newElm.id = Int32(timeScoreActivityAPI.id)
            newElm.timeScoreId = TimeScoresDataHelpers.getFunc.searchTimeScoreById(id: timeScoreActivityAPI.timeScoreId, userConnected: userConnected)
            newElm.activityId = ActivitiesDataHelpers.getFunc.searchActivityById(id: timeScoreActivityAPI.activityId, userConnected: userConnected)
            newElm.running = timeScoreActivityAPI.running
            newElm.modifiedDate = timeScoreActivityAPI.modifiedDate
            newElm.userId = userConnected
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
    }
}
