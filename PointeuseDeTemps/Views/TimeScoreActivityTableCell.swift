//
//  TimeScoreActivityTableCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 23/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import MapKit

class TimeScoreActivityTableCell: UITableViewCell, CLLocationManagerDelegate {

    @IBOutlet weak var activityNameLabel: LabelH2TS!
    @IBOutlet weak var activityImageView: ImageViewTS!
    @IBOutlet weak var activityStatusLabel: UILabel!
    @IBOutlet weak var activityTimeTitleLabel: LabelH3TitleTS!
    @IBOutlet weak var activityTimeLabel: LabelH3TS!
    @IBOutlet weak var toggleButton: UIButton!
    
    var timeScoreActivity: TimeScoreActivities!
    var timeScore: TimeScores!
    var userConnected: Users!
    
    var locationManager = CLLocationManager()
    
    func initCell(timeScoreActivity: TimeScoreActivities, timeScore: TimeScores, userConnected: Users) {
        self.timeScoreActivity = timeScoreActivity
        self.timeScore = timeScore
        self.userConnected = userConnected
        
        locationManager.delegate = self
        
        activityStatusLabel.text = RSC_RUNNING
        toggleButton.setTitle(RSC_ACTIVATE, for: .normal)
        activityNameLabel.text = timeScoreActivity.activityId!.activityName
        activityTimeTitleLabel.text = RSC_TOTALDURATION
        
        if timeScoreActivity.activityId!.image != nil, let image = timeScoreActivity.activityId!.image as? UIImage {
            activityImageView.image = image
            toggleButton.isHidden = true
            activityImageView.isHidden = false
        } else {
            toggleButton.isHidden = false
            activityImageView.isHidden = true
        }
        
        var totalDuration: Double = 0
        for elm in timeScoreActivity.timeScoreActivityDetails!.allObjects {
            if let element = elm as? TimeScoreActivityDetails {
                if !element.running {
                    totalDuration += DateHelper.getFunc.getDurationBetween2Dates(startDate: element.startDateTime!, endDate: element.endDateTime!)
                }
            }
        }
        if totalDuration > 0 {
            activityTimeLabel.text = DateHelper.getFunc.getDurationFromDouble(duration: totalDuration)
        } else {
            activityTimeLabel.text = RSC_NODURATION
        }
        
        activityImageView.isUserInteractionEnabled = true
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(imageView_Click))
        activityImageView.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(imageView_Click))
        toggleButton.addGestureRecognizer(tap2)
        
        if timeScoreActivity.running {
            activityStatusLabel.isHidden = false
            toggleButton.setTitle(RSC_DESACTIVATE, for: .normal)
        } else {
            activityStatusLabel.isHidden = true
            toggleButton.setTitle(RSC_ACTIVATE, for: .normal)
        }
    }
    
    @objc func imageView_Click() {
        if timeScoreActivity.running {
            if timeScoreActivity.activityId!.gpsPosition {
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            } else {
                if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: false, coordinates: nil, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = true
                }
            }
        } else {
            if timeScoreActivity.activityId!.gpsPosition {
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            } else {
                if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: true, coordinates: nil, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = false
                }
            }
        }
        NotificationCenter.default.post(name: .changeRunningStatusInTimeScoreActivity, object: self, userInfo: ["timeScoreActivity": timeScoreActivity])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            locationManager.stopUpdatingLocation()
            let position = locations[0]
            let coordinates = position.coordinate
            if timeScoreActivity.running {
                if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: false, coordinates: coordinates, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = true
                }
            } else {
                if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: true, coordinates: coordinates, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = false
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if timeScoreActivity.running {
            if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: false, coordinates: nil, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = true
            }
        } else {
            if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: true, coordinates: nil, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = false
            }
        }
        NotificationCenter.default.post(name: .changeRunningStatusInTimeScoreActivity, object: self, userInfo: ["timeScoreActivity": timeScoreActivity])
    }
}
