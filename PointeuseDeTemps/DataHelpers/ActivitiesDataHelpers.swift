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
                print("Delete ok")
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
            return true
        } else {
            return false
        }
    }
}
