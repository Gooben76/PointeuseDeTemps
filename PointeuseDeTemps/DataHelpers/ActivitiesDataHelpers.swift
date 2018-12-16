//
//  ActivitiesDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 15/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData

class ActivitiesDataHelpers {
    
    static let getFunc = ActivitiesDataHelpers()
    
    func getAllActivities(userConnected: Users!) -> [Activities]? {
        if let result = userConnected.activities!.allObjects as? [Activities] {
            let sortedResult = result.sorted(by: { $0.order < $1.order})
            return sortedResult
        }
        return nil
    }
    
    func setNewActivity(activityName: String, userConnected: Users, withoutSynchronization: Bool = false) -> Bool {
        if activityName != "" {
            let elm = searchActivityByName(activityName: activityName, userConnected: userConnected)
            guard elm == nil else {return false}
            let newElm = Activities(context: context)
            newElm.activityName = activityName
            newElm.gpsPosition = false
            let nextOrder = getNextOrderNumber(userConnected: userConnected)
            newElm.order = nextOrder
            newElm.modifiedDate = Date()
            newElm.userID = userConnected
            appDelegate.saveContext()
            
            if userConnected.synchronization && !withoutSynchronization {
                APIActivities.getFunc.createToAPI(activityId: newElm, token: "") { (newAPI) in
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
    
    func setNewActivityFromActivityAPI(activityAPI: ActivityAPI!, userConnected: Users) -> Bool {
        if activityAPI.activityName != "" {
            let newElm = Activities(context: context)
            newElm.id = Int32(activityAPI.id)
            newElm.activityName = activityAPI.activityName
            newElm.gpsPosition = activityAPI.gpsPosition
            newElm.order = Int32(activityAPI.order)
            newElm.modifiedDate = activityAPI.modifiedDate
            newElm.userID = userConnected
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
    }
    
    func delActivity(activity: Activities!, userConnected: Users) -> Bool {
        if activity != nil {
            let deleteId = activity.id
            context.delete(activity)
            do {
                try context.save()
                
                if userConnected.synchronization {
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
    
    func setActivity(activity: Activities!, userConnected: Users!, withoutSynchronization: Bool = false) -> Bool {
        if activity != nil {
            let elm = searchActivityByName(activityName: activity.activityName!, userConnected: userConnected)
            guard elm != nil else {return false}
            elm!.setValue(activity.order, forKey: "order")
            elm!.setValue(activity.image, forKey: "image")
            elm!.setValue(activity.activityName, forKey: "activityName")
            elm!.setValue(activity.gpsPosition, forKey: "gpsPosition")
            elm!.setValue(Date(), forKey: "modifiedDate")
            do {
                try context.save()
                
                if userConnected.synchronization && !withoutSynchronization {
                    APIActivities.getFunc.updateToAPI(activityId: elm!, token: "", completion: { (httpcode) in
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
    
    func searchActivityByName(activityName : String, userConnected: Users!) -> Activities? {
        if let result = userConnected.activities?.allObjects as? [Activities] {
            let predicate1 = NSPredicate(format: "activityName like %@", activityName)
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [Activities] {
                if resultNS.count > 0 {
                    let sortedResult = resultNS.sorted(by: { $0.activityName! < $1.activityName!})
                    return sortedResult[0]
                }
            }
        }
        return nil
    }
    
    func existActivityOrder(order: Int32, userConnected: Users!) -> Bool {
        if let result = userConnected.activities?.allObjects as? [Activities] {
            let predicate1 = NSPredicate(format: "order == \(order)")
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [Activities] {
                if resultNS.count > 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func existActivityName(activityName: String, userConnected: Users!) -> Bool {
        if let result = userConnected.activities?.allObjects as? [Activities] {
            let predicate1 = NSPredicate(format: "activityName like %@", activityName)
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [Activities] {
                if resultNS.count > 0 {
                    return true
                }
            }
        }
        return false
    }
    
    private func getNextOrderNumber(userConnected: Users!) -> Int32 {
        if let result = userConnected.activities!.allObjects as? [Activities] {
            if result.count > 0 {
                let sortedResult = result.sorted(by: { $0.order > $1.order})
                let lastValue = sortedResult[0].order
                let (q, _) = lastValue.quotientAndRemainder(dividingBy: 10)
                let newValue = (q+1)*10
                return newValue
            }
        }
        return 10
    }
    
    func searchActivityById(id: Int, userConnected: Users!) -> Activities? {
        if let result = userConnected.activities?.allObjects as? [Activities] {
            let predicate1 = NSPredicate(format: "id == \(id)")
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [Activities] {
                if resultNS.count > 0 {
                    let sortedResult = resultNS.sorted(by: { $0.activityName! < $1.activityName!})
                    return sortedResult[0]
                }
            }
        }
        return nil
    }
}
