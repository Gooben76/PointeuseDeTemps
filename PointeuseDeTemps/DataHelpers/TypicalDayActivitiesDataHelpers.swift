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
    
    func getAllTypicalDayActivities(userConnected: Users!) -> [TypicalDayActivities]? {
        if let result = userConnected.typicalDaysActivities?.allObjects as? [TypicalDayActivities] {
            return result
        }
        return nil
    }
    
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
    
    func setNewTypicalDayActivity(typicalDay: TypicalDays?, activity: Activities?,userConnected: Users, withoutSynchronization: Bool = false) -> Bool {
        if typicalDay != nil && activity != nil {
            let elm = searchTypicalDayActivityByTypicalDayAndActivity(typicalDay: typicalDay!, activity: activity!, userConnected: userConnected)
            guard elm == nil else {return false}
            let newElm = TypicalDayActivities(context: context)
            newElm.typicalDayId = typicalDay!
            newElm.activityId = activity!
            newElm.userId = userConnected
            newElm.modifiedDate = Date()
            appDelegate.saveContext()
            
            if userConnected.synchronization && !withoutSynchronization {
                APITypicalDayActivities.getFunc.createToAPI(typicalDayAvtivityId: newElm, token: "") { (newAPI) in
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
    
    func setTypicalDayActivity(typicalDay: TypicalDays!, activity: Activities!, userConnected: Users!, withoutSynchronization: Bool = false) -> Bool {
        if typicalDay != nil && activity != nil && userConnected != nil {
            let elm = searchTypicalDayActivityByTypicalDayAndActivity(typicalDay: typicalDay, activity: activity, userConnected: userConnected)
            guard elm != nil else {return false}
            elm!.setValue(Date(), forKey: "modifiedDate")
            do {
                try context.save()
                
                if userConnected.synchronization && !withoutSynchronization {
                    APITypicalDayActivities.getFunc.updateToAPI(typicalDayAvtivityId: elm!, token: "", completion: { (httpcode) in
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
    
    func delTypicalDayActivity(typicalDayActivity: TypicalDayActivities!, userConnected: Users) -> Bool {
        if typicalDayActivity != nil {
            let deleteId = typicalDayActivity.id
            context.delete(typicalDayActivity)
            do {
                try context.save()
                
                if userConnected.synchronization {
                    APITypicalDayActivities.getFunc.deleteToAPI(id: deleteId, token: "") { (httpcode) in
                        //
                    }
                }
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
    
    func delTypicalDayActivitiesFromTypicalDay(typicalDay: TypicalDays!, userConnected: Users) -> Bool {
        if typicalDay != nil {
            var deleteIds = [Int32]()
            if let records = typicalDay!.typicalDayActivities?.allObjects as? [TypicalDayActivities] {
                for  elm in records {
                    deleteIds.append(elm.id)
                    context.delete(elm)
                }
                do {
                    try context.save()
                    
                    if userConnected.synchronization {
                        for deleteId in deleteIds {
                            APITypicalDayActivities.getFunc.deleteToAPI(id: deleteId, token: "") { (httpcode) in
                                //
                            }
                        }
                    }
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
    
    func searchTypicalDayActivityById(id: Int, userConnected: Users!) -> TypicalDayActivities? {
        if let result = userConnected.typicalDaysActivities?.allObjects as? [TypicalDayActivities] {
            let predicate1 = NSPredicate(format: "id == \(id)")
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [TypicalDayActivities] {
                if resultNS.count > 0 {
                    return resultNS[0]
                }
            }
        }
        return nil
    }
    
    func setNewTypicalDayActivityFromTypicalDayActivityAPI(typicalDayActivityAPI: TypicalDayActivityAPI!, userConnected: Users) -> Bool {
        if typicalDayActivityAPI.typicalDayId > 0 && typicalDayActivityAPI.activityId > 0 {
            let newElm = TypicalDayActivities(context: context)
            newElm.id = Int32(typicalDayActivityAPI.id)
            newElm.typicalDayId = TypicalDaysDataHelpers.getFunc.searchTypicalDayById(id: typicalDayActivityAPI.typicalDayId, userConnected: userConnected)
            newElm.activityId = ActivitiesDataHelpers.getFunc.searchActivityById(id: typicalDayActivityAPI.activityId, userConnected: userConnected)
            newElm.modifiedDate = typicalDayActivityAPI.modifiedDate
            newElm.userId = userConnected
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
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
