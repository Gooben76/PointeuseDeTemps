//
//  TimeScoreActivityDetailsDataHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 3/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class TimeScoreActivityDetailsDataHelpers {
    
    static let getFunc = TimeScoreActivityDetailsDataHelpers()
    
    func getTimeScoreActivityDetailssForATimeScoreActivity(timeScoreActivity: TimeScoreActivities, userConnected: Users) -> [TimeScoreActivityDetails]? {
        if let result = userConnected.timeScoreActivityDetails?.allObjects as? [TimeScoreActivityDetails] {
            let predicate1 = NSPredicate(format: "timeScoreActivityId == %@", timeScoreActivity)
            if let filterResult = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivityDetails] {
                if filterResult.count > 0 {
                    let sortedResult = filterResult.sorted(by: { $0.timeScoreActivityId!.activityId!.order < $1.timeScoreActivityId!.activityId!.order})
                    return sortedResult
                }
            }
        }
        return nil
    }
    
    func setNewTimeScoreActivityDetail(timeScoreActivity: TimeScoreActivities, coordinates: CLLocationCoordinate2D?, userConnected: Users) -> Bool {
        let newData = TimeScoreActivityDetails(context: context)
        newData.timeScoreActivityId = timeScoreActivity
        newData.startDateTime = Date()
        newData.running = true
        if coordinates != nil {
            newData.startLatitude = coordinates!.latitude
            newData.startLongitude = coordinates!.longitude
        }
        newData.userId = userConnected
        newData.modifiedDate = Date()
        appDelegate.saveContext()
        return true
    }
    
    func updateTimeScoreActivityDetail(timeScoreActivity: TimeScoreActivities, coordinates: CLLocationCoordinate2D?, userConnected: Users) -> Bool {
        if let result = userConnected.timeScoreActivityDetails?.allObjects as? [TimeScoreActivityDetails] {
            let predicate1 = NSPredicate(format: "timeScoreActivityId == %@ AND running == true", timeScoreActivity)
            if let filterResult = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivityDetails] {
                if filterResult.count > 0 {
                    filterResult[0].setValue(false, forKey: "running")
                    filterResult[0].setValue(Date(), forKey: "endDateTime")

                    let duration: Double = DateHelper.getFunc.getDurationBetween2Dates(startDate: filterResult[0].startDateTime!, endDate: filterResult[0].endDateTime!)
                    filterResult[0].setValue(duration, forKey: "duration")
                    if coordinates != nil {
                        filterResult[0].setValue(coordinates!.latitude, forKey: "endLatitude")
                        filterResult[0].setValue(coordinates!.longitude, forKey: "endLongitude")
                    }
                    filterResult[0].setValue(Date(), forKey: "modifiedDate")
                    do {
                        try context.save()
                        return true
                    } catch {
                        print(error.localizedDescription)
                        return false
                    }
                }
            }
        }
        return true
    }
}
