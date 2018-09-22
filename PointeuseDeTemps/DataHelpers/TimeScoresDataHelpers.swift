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
        if date != nil {
            let elm = searchTimeScoreByDate(date: date, userConnected: userConnected)
            guard elm == nil else {return false}
            let newTimeScore = TimeScores(context: context)
            newTimeScore.date = date
            if typicalDay != nil {
                newTimeScore.typicalDayId = typicalDay!
            }
            newTimeScore.modifiedDate = Date()
            newTimeScore.userId = userConnected
            appDelegate.saveContext()
            
            if typicalDay != nil {
                if let allSubData = typicalDay!.typicalDayActivities?.allObjects as? [TypicalDayActivities] {
                    for elm in allSubData {
                        
                    }
                }
            }
            return true
        } else {
            return false
        }
    }
    
    func delTimeScore(timeScore: TimeScores!) -> Bool {
        if timeScore != nil {
            context.delete(timeScore)
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
}
