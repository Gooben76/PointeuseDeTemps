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
    var listenGPS: Bool = false
    
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
                if element.startDateTime != nil && element.endDateTime != nil {
                    totalDuration += element.duration
                }
            }
        }
        if totalDuration > 0 {
            activityTimeLabel.text = DateHelper.getFunc.getDurationFromDouble(duration: totalDuration)
        } else {
            activityTimeLabel.text = RSC_NODURATION
        }
        
        activityImageView.isUserInteractionEnabled = true
        toggleButton.isUserInteractionEnabled = true
        
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
        activityImageView.isUserInteractionEnabled = false
        toggleButton.isUserInteractionEnabled = false
        print("Start")
        if timeScoreActivity.running {
            if timeScoreActivity.activityId!.gpsPosition {
                print("start GPS")
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                listenGPS = true
            } else {
                if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: false, coordinates: nil, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = true
                    activityImageView.isUserInteractionEnabled = true
                    toggleButton.isUserInteractionEnabled = true
                    print("Save end no GPS")
                }
            }
        } else {
            if timeScoreActivity.activityId!.gpsPosition {
                print("start GPS")
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                listenGPS = true
            } else {
                if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: true, coordinates: nil, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = false
                    activityImageView.isUserInteractionEnabled = true
                    toggleButton.isUserInteractionEnabled = true
                    print("Save start no GPS")
                }
            }
        }
        NotificationCenter.default.post(name: .changeRunningStatusInTimeScoreActivity, object: self, userInfo: ["timeScoreActivity": timeScoreActivity])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 && listenGPS {
            print("Stop GPS")
            locationManager.stopUpdatingLocation()
            listenGPS = false
            let position = locations[0]
            let coordinates = position.coordinate
            if timeScoreActivity.running {
                if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: false, coordinates: coordinates, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = true
                    activityImageView.isUserInteractionEnabled = true
                    toggleButton.isUserInteractionEnabled = true
                    print("Save end")
                }
            } else {
                if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: true, coordinates: coordinates, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = false
                    activityImageView.isUserInteractionEnabled = true
                    toggleButton.isUserInteractionEnabled = true
                    print("Save start")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erreur")
        if timeScoreActivity.running {
            if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: false, coordinates: nil, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = true
                    activityImageView.isUserInteractionEnabled = true
                    toggleButton.isUserInteractionEnabled = true
                print("Save end erreur")
            }
        } else {
            if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: true, coordinates: nil, userConnected: userConnected!) {
                    activityStatusLabel.isHidden = false
                    activityImageView.isUserInteractionEnabled = true
                    toggleButton.isUserInteractionEnabled = true
                print("Save start erreur")
            }
        }
        NotificationCenter.default.post(name: .changeRunningStatusInTimeScoreActivity, object: self, userInfo: ["timeScoreActivity": timeScoreActivity])
    }
}
