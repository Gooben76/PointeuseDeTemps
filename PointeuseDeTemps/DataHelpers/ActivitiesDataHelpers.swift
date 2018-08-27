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
    
    func getAllActivities() -> [Activities] {
        var activities = [Activities]()
        let query: NSFetchRequest<Activities> = Activities.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "activityName", ascending: true)
        query.sortDescriptors?.append(sortDescriptor)
        do {
            activities = try context.fetch(query)
        } catch {
            print(error.localizedDescription)
        }
        return activities
    }
    
    func setNewActivity(activityName: String) -> Bool {
        if activityName != "" {
            let newActivity = Activities(context: context)
            newActivity.activityName = activityName
            newActivity.gpsPosition = false
            newActivity.order = 10
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
    
    func setActivity(activity: Activities!) -> Bool {
        if activity != nil {
            let act = searchActivityByName(activityName: activity.activityName!)
            guard act != nil else {return false}
            act!.setValue(activity.order, forKey: "order")
            act!.setValue(activity.image, forKey: "image")
            act!.setValue(activity.activityName, forKey: "activityName")
            act!.setValue(activity.gpsPosition, forKey: "gpsPosition")
            do {
                try context.save()
                print("updated")
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    func searchActivityByName(activityName : String) -> Activities? {
        let query: NSFetchRequest<Activities> = Activities.fetchRequest()
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
    }
}
