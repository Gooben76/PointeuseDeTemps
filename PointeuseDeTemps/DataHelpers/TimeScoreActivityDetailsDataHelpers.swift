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
    
    func getAllTimeScoreActivityDetails(userConnected: Users!) -> [TimeScoreActivityDetails]? {
        if let result = userConnected.timeScoreActivityDetails?.allObjects as? [TimeScoreActivityDetails] {
            return result
        }
        return nil
    }
    
    func getTimeScoreActivityDetailssForATimeScoreActivity(timeScoreActivity: TimeScoreActivities, userConnected: Users) -> [TimeScoreActivityDetails]? {
        if let result = userConnected.timeScoreActivityDetails?.allObjects as? [TimeScoreActivityDetails] {
            let predicate1 = NSPredicate(format: "timeScoreActivityId == %@", timeScoreActivity)
            if let filterResult = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivityDetails] {
                if filterResult.count > 0 {
                    let sortedResult = filterResult.sorted(by: { $0.startDateTime! < $1.startDateTime!})
                    return sortedResult
                }
            }
        }
        return nil
    }
    
    func setNewTimeScoreActivityDetail(timeScoreActivity: TimeScoreActivities, coordinates: CLLocationCoordinate2D?, userConnected: Users, withoutSynchronization: Bool = false) -> Bool {
        let newElm = TimeScoreActivityDetails(context: context)
        newElm.timeScoreActivityId = timeScoreActivity
        newElm.startDateTime = Date()
        newElm.running = true
        if coordinates != nil {
            newElm.startLatitude = coordinates!.latitude
            newElm.startLongitude = coordinates!.longitude
        }
        newElm.userId = userConnected
        newElm.modifiedDate = Date()
        appDelegate.saveContext()
        
        if userConnected.synchronization && !withoutSynchronization {
            APITimeScoreActivityDetails.getFunc.createToAPI(timeScoreActivityDetailId: newElm, token: "") { (newAPI) in
                if newAPI != nil, newAPI!.id != -1 {
                    newElm.id = Int32(newAPI!.id)
                    newElm.modifiedDate = Date()
                    appDelegate.saveContext()
                }
            }
        }
        return true
    }
    
    func updateTimeScoreActivityDetail(timeScoreActivity: TimeScoreActivities, coordinates: CLLocationCoordinate2D?, userConnected: Users, withoutSynchronization: Bool = false) -> Bool {
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
                        
                        if userConnected.synchronization && !withoutSynchronization {
                            APITimeScoreActivityDetails.getFunc.updateToAPI(timeScoreActivityDetailId: filterResult[0], token: "", completion: { (httpcode) in
                                //
                            })
                        }
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
    
    func searchTimeScoreActivityDetailById(id: Int, userConnected: Users!) -> TimeScoreActivityDetails? {
        if let result = userConnected.timeScoreActivityDetails?.allObjects as? [TimeScoreActivityDetails] {
            let predicate1 = NSPredicate(format: "id == \(id)")
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivityDetails] {
                if resultNS.count > 0 {
                    return resultNS[0]
                }
            }
        }
        return nil
    }
    
    func searchTimeScoreActivityDetailByTimeScoreActivityAndStartDateTime(timeScoreActivity: TimeScoreActivities, startDateTime: Date, userConnected: Users!) -> TimeScoreActivityDetails? {
        if let result = userConnected.timeScoreActivityDetails?.allObjects as? [TimeScoreActivityDetails] {
            let predicate1 = NSPredicate(format: "timeScoreActivityId == %@ && startDateTime == %@", timeScoreActivity, startDateTime as CVarArg)
            if let resultNS = (result as NSArray).filtered(using: predicate1) as? [TimeScoreActivityDetails] {
                if resultNS.count > 0 {
                    return resultNS[0]
                }
            }
        }
        return nil
    }
    
    func setNewTimeScoreActivityDetailFromTimeScoreActivityDetailAPI(timeScoreActivityDetailAPI: TimeScoreActivityDetailAPI!, userConnected: Users) -> Bool {
        if timeScoreActivityDetailAPI.timeScoreActivityId > 0 && timeScoreActivityDetailAPI.startDateTime.timeIntervalSince1970 != 0 {
            let newElm = TimeScoreActivityDetails(context: context)
            newElm.id = Int32(timeScoreActivityDetailAPI.id)
            newElm.timeScoreActivityId = TimeScoreActivitiesDataHelpers.getFunc.searchTimeScoreActivityById(id: timeScoreActivityDetailAPI.timeScoreActivityId, userConnected: userConnected)
            newElm.startDateTime = timeScoreActivityDetailAPI.startDateTime
            newElm.running = timeScoreActivityDetailAPI.running
            newElm.endDateTime = timeScoreActivityDetailAPI.endDateTime
            newElm.startLatitude = timeScoreActivityDetailAPI.startLatitude
            newElm.startLongitude = timeScoreActivityDetailAPI.startLongitude
            newElm.endLatitude = timeScoreActivityDetailAPI.endLatitude
            newElm.endLongitude = timeScoreActivityDetailAPI.endLongitude
            newElm.modifiedDate = timeScoreActivityDetailAPI.modifiedDate
            newElm.duration = timeScoreActivityDetailAPI.duration
            newElm.userId = userConnected
            appDelegate.saveContext()
            return true
        } else {
            return false
        }
    }
    
    func setTimeScoreActivityDetail(timeScoreActivityDetail: TimeScoreActivityDetails, userConnected: Users!, withoutSynchronization: Bool = false) -> Bool {
        let elm = searchTimeScoreActivityDetailByTimeScoreActivityAndStartDateTime(timeScoreActivity: timeScoreActivityDetail.timeScoreActivityId!, startDateTime: timeScoreActivityDetail.startDateTime!, userConnected: userConnected)
        guard elm != nil else {return false}
        elm!.setValue(timeScoreActivityDetail.running, forKey: "running")
        elm!.setValue(timeScoreActivityDetail.duration, forKey: "duration")
        elm!.setValue(timeScoreActivityDetail.startLatitude, forKey: "startLatitude")
        elm!.setValue(timeScoreActivityDetail.startLongitude, forKey: "startLongitude")
        elm!.setValue(timeScoreActivityDetail.endDateTime, forKey: "endDateTime")
        elm!.setValue(timeScoreActivityDetail.endLatitude, forKey: "endLatitude")
        elm!.setValue(timeScoreActivityDetail.endLongitude, forKey: "endLongitude")
        elm!.setValue(Date(), forKey: "modifiedDate")
        do {
            try context.save()
            
            if userConnected.synchronization && !withoutSynchronization {
                APITimeScoreActivityDetails.getFunc.updateToAPI(timeScoreActivityDetailId: elm!, token: "", completion: { (httpcode) in
                    //
                })
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
