//
//  TypicalDayActivitiesDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 14/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData

class TypicalDayActivitiesDataHelpers {
    
    static let getFunc = TypicalDayActivitiesDataHelpers()
    
    func getTypicalDayActivitiesForATypicalDay(typicalDay: TypicalDays, userConnected: Users) -> [TypicalDayActivities]? {
        if let result = userConnected.typicalDaysActivities?.allObjects as? [TypicalDayActivities] {
            let predicate1 = NSPredicate(format: "typicalDayId == %@", typicalDay)
            if let filterResult = (result as NSArray).filtered(using: predicate1) as? [TypicalDayActivities] {
                if filterResult.count > 0 {
                    let sortedResult = filterResult.sorted(by: { $0.activityId!.order < $1.activityId!.order})
                    return sortedResult
                }
            }
        }
        return nil
    }
    
    func setNewTypicalDayActivity(typicalDay: TypicalDays?, activity: Activities?,userConnected: Users) -> Bool {
        if typicalDay != nil && activity != nil {
            let elm = searchTypicalDayActivityByTypicalDayAndActivity(typicalDay: typicalDay!, activity: activity!, userConnected: userConnected)
            guard elm == nil else {return false}
            let newData = TypicalDayActivities(context: context)
            newData.typicalDayId = typicalDay!
            newData.activityId = activity!
            newData.userId = userConnected
            newData.modifiedDate = Date()
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
    }
    
    func setTypicalDayActivity(typicalDay: TypicalDays!, activity: Activities!, userConnected: Users!) -> Bool {
        if typicalDay != nil && activity != nil && userConnected != nil {
            let elm = searchTypicalDayActivityByTypicalDayAndActivity(typicalDay: typicalDay, activity: activity, userConnected: userConnected)
            guard elm != nil else {return false}
            elm!.setValue(Date(), forKey: "modifiedDate")
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
    
    func delTypicalDayActivity(typicalDayActivity: TypicalDayActivities!) -> Bool {
        if typicalDayActivity != nil {
            context.delete(typicalDayActivity)
            do {
                try context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
    
    func searchTypicalDayActivityByTypicalDayAndActivity(typicalDay: TypicalDays, activity: Activities, userConnected: Users!) -> TypicalDayActivities? {
        if let result = userConnected.typicalDaysActivities?.allObjects as? [TypicalDayActivities] {
            let predicate1 = NSPredicate(format: "typicalDayId == %@ AND activityId == %@", typicalDay, activity)
            if let filterResult = (result as NSArray).filtered(using: predicate1) as? [TypicalDayActivities] {
                if filterResult.count > 0 {
                    return filterResult[0]
                }
            }
        }
        return nil
    }
    
    func delTypicalDayActivitiesFromTypicalDay(typicalDay: TypicalDays!) -> Bool {
        if typicalDay != nil {
            if let records = typicalDay!.typicalDayActivities?.allObjects as? [TypicalDayActivities] {
                for  elm in records {
                    context.delete(elm)
                }
                do {
                    try context.save()
                    return true
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return false
    }
    
    func getAllTypicalDayActivitiesDetailsForTypicalDay(typicalDay: TypicalDays!, userConnected: Users!) -> [TypicalDayActivitiesDetails]? {
        if typicalDay != nil {
            var table: [TypicalDayActivitiesDetails] = [TypicalDayActivitiesDetails]()
            let activities = ActivitiesDataHelpers.getFunc.getAllActivities(userConnected: userConnected)
            if activities != nil, activities!.count > 0 {
                for elm in activities! {
                    let new = TypicalDayActivitiesDetails(activity: elm)
                    table.append(new)
                }
                if let records = typicalDay!.typicalDayActivities?.allObjects as? [TypicalDayActivities] {
                    for elm in records {
                        let find = table.first(where: {$0.activity == elm.activityId!})
                        if find != nil {
                            find!.setSelected(true)
                        }
                    }
                }
                return table
            }
        }
        return nil
    }
}

class TypicalDayActivitiesDetails {
    
    private var _activity: Activities
    private var _selected: Bool
    
    var activity: Activities {
        return _activity
    }
    var selected: Bool {
        return _selected
    }
    
    init(activity: Activities) {
        self._activity = activity
        self._selected = false
    }
    
    func setSelected(_ value: Bool) {
        self._selected = value
    }
}
