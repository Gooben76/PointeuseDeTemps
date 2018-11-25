//
//  TypicalDaysDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 2/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData

class TypicalDaysDataHelpers {
    
    static let getFunc = TypicalDaysDataHelpers()
    
    func getAllTypicalDays(userConnected: Users!) -> [TypicalDays]? {
        if let result = userConnected.typicalDays?.allObjects as? [TypicalDays] {
            let sortedResult = result.sorted(by: { $0.typicalDayName! < $1.typicalDayName!})
            return sortedResult
        }
        return nil
    }
    
    func setNewTypicalDay(typicalDayName: String, userConnected: Users) -> Bool {
        if typicalDayName != "" {
            let elm = searchTypicalDayByName(typicalDayName: typicalDayName, userConnected: userConnected)
            guard elm == nil else {return false}
            let newElm = TypicalDays(context: context)
            newElm.typicalDayName = typicalDayName
            newElm.modifiedDate = Date()
            newElm.userID = userConnected
            appDelegate.saveContext()
            
            if userConnected.synchronization {
                APITypicalDays.getFunc.createToAPI(typicalDayId: newElm, token: "") { (newAPI) in
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
    
    func delTypicalDay(typicalDay: TypicalDays!, userConnected: Users) -> Bool {
        if typicalDay != nil {
            let deleteId = typicalDay.id
            if TypicalDayActivitiesDataHelpers.getFunc.delTypicalDayActivitiesFromTypicalDay(typicalDay: typicalDay, userConnected: userConnected) {
                context.delete(typicalDay)
                do {
                    try context.save()
                    
                    if userConnected.synchronization {
                        APITypicalDays.getFunc.deleteToAPI(id: deleteId, token: "") { (httpcode) in
                            print("http response code : \(httpcode)")
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
    
    func setTypicalDay(typicalDay: TypicalDays!, userConnected: Users!) -> Bool {
        if typicalDay != nil {
            let elm = searchTypicalDayByName(typicalDayName: typicalDay!.typicalDayName!, userConnected: userConnected)
            guard elm != nil else {return false}
            elm!.setValue(typicalDay.typicalDayName, forKey: "typicalDayName")
            elm!.setValue(Date(), forKey: "modifiedDate")
            do {
                try context.save()
                if userConnected.synchronization {
                    APITypicalDays.getFunc.updateToAPI(typicalDayId: elm!, token: "", completion: { (httpcode) in
                        print("http response code : \(httpcode)")
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
    
    func searchTypicalDayByName(typicalDayName : String, userConnected: Users!) -> TypicalDays? {
        if let days = userConnected.typicalDays?.allObjects as? [TypicalDays] {
            let predicate1 = NSPredicate(format: "typicalDayName like %@", typicalDayName)
            if let result = (days as NSArray).filtered(using: predicate1) as? [TypicalDays] {
                if result.count > 0 {
                    let sortedResult = result.sorted(by: { $0.typicalDayName! < $1.typicalDayName!})
                    return sortedResult[0]
                } else {
                    return nil
                }
            }
            return nil
        }
        return nil
    }
    
    func searchTypicalDayById(id: Int, userConnected: Users!) -> TypicalDays? {
        if let result = userConnected.typicalDays?.allObjects as? [TypicalDays] {
            let predicate1 = NSPredicate(format: "id == \(id)")
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [TypicalDays] {
                if resultNS.count > 0 {
                    return resultNS[0]
                }
            }
        }
        return nil
    }
    
    func setNewTypicalDayFromTypicalDayAPI(typicalDayAPI: TypicalDayAPI!, userConnected: Users) -> Bool {
        if typicalDayAPI.typicalDayName != "" {
            let newElm = TypicalDays(context: context)
            newElm.id = Int32(typicalDayAPI.id)
            newElm.typicalDayName = typicalDayAPI.typicalDayName
            newElm.modifiedDate = typicalDayAPI.modifiedDate
            newElm.userID = userConnected
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
    }
}
