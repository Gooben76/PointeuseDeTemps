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
        /*let query: NSFetchRequest<TypicalDays> = TypicalDays.fetchRequest()
        query.predicate = NSPredicate(format: "userId like %@", userConnected)
        
        query.sortDescriptors?.append(sortDescriptor)
        do {
            days = try context.fetch(query)
        } catch {
            print(error.localizedDescription)
        }*/
        return nil
    }
    
    func setNewTypicalDay(typicalDayName: String, userConnected: Users) -> Bool {
        if typicalDayName != "" {
            let elm = searchTypicalDayByName(typicalDayName: typicalDayName, userConnected: userConnected)
            guard elm == nil else {return false}
            let newDay = TypicalDays(context: context)
            newDay.typicalDayName = typicalDayName
            newDay.modifiedDate = Date()
            newDay.userID = userConnected
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
    }
    
    func delTypicalDay(typicalDay: TypicalDays!) -> Bool {
        if typicalDay != nil {
            context.delete(typicalDay)
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
    
    func setTypicalDay(typicalDay: TypicalDays!, userConnected: Users!) -> Bool {
        if typicalDay != nil {
            let elm = searchTypicalDayByName(typicalDayName: typicalDay!.typicalDayName!, userConnected: userConnected)
            guard elm != nil else {return false}
            elm!.setValue(typicalDay.typicalDayName, forKey: "typicalDayName")
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
        /*let query: NSFetchRequest<TypicalDays> = TypicalDays.fetchRequest()
        let predicate1 = NSPredicate(format: "typicalDayName like %@", typicalDayName)
        let predicate2 = NSPredicate(format: "userId like %@", userConnected)
        let predicateCompount = NSCompoundPredicate.init(type: .and, subpredicates: [predicate1,predicate2])
        query.predicate = predicateCompount
        do {
            var foundRecordsArray = [TypicalDays]()
            try foundRecordsArray = context.fetch(query)
            if foundRecordsArray.count > 0 {
                return foundRecordsArray[0]
            } else {
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }*/
    }
}
