//
//  TimeScoresDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 22/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData

class TimeScoresDataHelpers {
    
    static let getFunc = TimeScoresDataHelpers()
    
    func getAllTimeScores(userConnected: Users!) -> [TimeScores]? {
        if let result = userConnected.timeScores!.allObjects as? [TimeScores] {
            let sortedResult = result.sorted(by: { $0.date! > $1.date!})
            return sortedResult
        }
        return nil
    }
    
    func setNewTimeScore(date: Date, typicalDay: TypicalDays?, userConnected: Users) -> Bool {
        if date.timeIntervalSince1970 != 0 {
            let elm = searchTimeScoreByDate(date: date, userConnected: userConnected)
            guard elm == nil else {return false}
            let newElm = TimeScores(context: context)
            newElm.date = date
            if typicalDay != nil {
                newElm.typicalDayId = typicalDay!
            }
            newElm.modifiedDate = Date()
            newElm.userId = userConnected
            appDelegate.saveContext()
            
            if userConnected.synchronization {
                APITimeScores.getFunc.createToAPI(timeScoreId: newElm, token: "") { (newAPI) in
                    if newAPI != nil, newAPI!.id != -1 {
                        newElm.id = Int32(newAPI!.id)
                        newElm.modifiedDate = Date()
                        appDelegate.saveContext()
                    }
                }
            }
            
            if typicalDay != nil {
                if let allSubData = typicalDay!.typicalDayActivities?.allObjects as? [TypicalDayActivities] {
                    for elm in allSubData {
                        if !TimeScoreActivitiesDataHelpers.getFunc.setNewTimeScoreActivity(timeScore: newElm, activity: elm.activityId!, userConnected: userConnected) {
                            print("Erreur de sauvegarde de TimeScoreActivities")
                        }
                    }
                }
            }
            return true
        } else {
            return false
        }
    }
    
    func delTimeScore(timeScore: TimeScores!, userConnected: Users) -> Bool {
        if timeScore != nil {
            let deleteId = timeScore.id
            context.delete(timeScore)
            do {
                try context.save()
                
                if userConnected.synchronization {
                    APITimeScores.getFunc.deleteToAPI(id: deleteId, token: "") { (httpcode) in
                        print("http response code : \(httpcode)")
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
    
    func searchTimeScoreByDate(date : Date, userConnected: Users!) -> TimeScores? {
        if let result = userConnected.timeScores?.allObjects as? [TimeScores] {
            let predicate1 = NSPredicate(format: "date == %@", date as CVarArg)
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [TimeScores] {
                if resultNS.count > 0 {
                    return resultNS[0]
                } else {
                    return nil
                }
            }
            return nil
        }
        return nil
    }
    
    func searchTimeScoreById(id: Int, userConnected: Users!) -> TimeScores? {
        if let result = userConnected.timeScores?.allObjects as? [TimeScores] {
            let predicate1 = NSPredicate(format: "id == \(id)")
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [TimeScores] {
                if resultNS.count > 0 {
                    return resultNS[0]
                }
            }
        }
        return nil
    }
    
    func setNewTimeScoreFromTimeScoreAPI(timeScoreAPI: TimeScoreAPI!, userConnected: Users) -> Bool {
        if timeScoreAPI.date.timeIntervalSince1970 != 0 {
            let newElm = TimeScores(context: context)
            newElm.id = Int32(timeScoreAPI.id)
            newElm.date = timeScoreAPI.date
            newElm.typicalDayId = TypicalDaysDataHelpers.getFunc.searchTypicalDayById(id: timeScoreAPI.typicalDayId!, userConnected: userConnected)
            newElm.modifiedDate = timeScoreAPI.modifiedDate
            newElm.userId = userConnected
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
    }
    
    func setTimeScore(timeScore: TimeScores!, userConnected: Users!) -> Bool {
        if timeScore != nil {
            let elm = searchTimeScoreByDate(date: timeScore.date!, userConnected: userConnected)
            guard elm != nil else {return false}
            elm!.setValue(timeScore.typicalDayId, forKey: "typicalDayId")
            elm!.setValue(Date(), forKey: "modifiedDate")
            do {
                try context.save()
                
                if userConnected.synchronization {
                    APITimeScores.getFunc.updateToAPI(timeScoreId: elm!, token: "", completion: { (httpcode) in
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
}
