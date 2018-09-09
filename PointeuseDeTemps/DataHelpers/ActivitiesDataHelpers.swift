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
            let sortedResult = result.sorted(by: { $0.activityName! < $1.activityName!})
            return sortedResult
        }
        return nil
        /*let query: NSFetchRequest<Activities> = Activities.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "activityName", ascending: true)
        query.sortDescriptors?.append(sortDescriptor)
        do {
            activities = try context.fetch(query)
        } catch {
            print(error.localizedDescription)
        }
        return activities
        */
    }
    
    func setNewActivity(activityName: String, userConnected: Users) -> Bool {
        if activityName != "" {
            let elm = searchActivityByName(activityName: activityName, userConnected: userConnected)
            guard elm == nil else {return false}
            let newActivity = Activities(context: context)
            newActivity.activityName = activityName
            newActivity.gpsPosition = false
            newActivity.order = 10
            newActivity.modifiedDate = Date()
            newActivity.userID = userConnected
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
    }
    
    func delActivity(activity: Activities!) -> Bool {
        if activity != nil {
            context.delete(activity)
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
    
    func setActivity(activity: Activities!, userConnected: Users!) -> Bool {
        if activity != nil {
            print("A mettre à jour")
            let act = searchActivityByName(activityName: activity.activityName!, userConnected: userConnected)
            guard act != nil else {return false}
            print("activité trouvée")
            act!.setValue(activity.order, forKey: "order")
            act!.setValue(activity.image, forKey: "image")
            act!.setValue(activity.activityName, forKey: "activityName")
            act!.setValue(activity.gpsPosition, forKey: "gpsPosition")
            act!.setValue(Date(), forKey: "modifiedDate")
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
    
    func searchActivityByName(activityName : String, userConnected: Users!) -> Activities? {
        if let result = userConnected.activities?.allObjects as? [Activities] {
            let predicate1 = NSPredicate(format: "activityName like %@", activityName)
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [Activities] {
                if resultNS.count > 0 {
                    let sortedResult = resultNS.sorted(by: { $0.activityName! < $1.activityName!})
                    return sortedResult[0]
                } else {
                    return nil
                }
            }
            return nil
        }
        return nil
        /*let query: NSFetchRequest<Activities> = Activities.fetchRequest()
        query.predicate = NSPredicate(format: "activityName like %@", activityName)
        do {
            var foundRecordsArray = [Activities]()
            try foundRecordsArray = context.fetch(query)
            if foundRecordsArray.count > 0 {
                return foundRecordsArray[0]
            } else {
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
        */
    }
}
