//
//  TimeScoreActivityTableCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 23/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class TimeScoreActivityTableCell: UITableViewCell {

    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var activityStatusLabel: UILabel!
    @IBOutlet weak var activityTimeLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    
    var timeScoreActivity: TimeScoreActivities!
    var timeScore: TimeScores!
    var userConnected: Users!
    
    func initCell(timeScoreActivity: TimeScoreActivities, timeScore: TimeScores, userConnected: Users) {
        self.timeScoreActivity = timeScoreActivity
        self.timeScore = timeScore
        self.userConnected = userConnected
        
        toggleButton.setTitle(RSC_ACTIVATE, for: .normal)
        activityNameLabel.text = timeScoreActivity.activityId!.activityName
        if timeScoreActivity.activityId!.image != nil, let image = timeScoreActivity.activityId!.image as? UIImage {
            activityImageView.image = image
            toggleButton.isHidden = true
            activityImageView.isHidden = false
        } else {
            toggleButton.isHidden = false
            activityImageView.isHidden = true
        }
        activityStatusLabel.textColor = UIColor.green
        activityStatusLabel.text = ""
        if let nbr = timeScoreActivity.timeScoreActivityDetails?.allObjects.count, nbr > 0 {
            activityTimeLabel.text = "Nombre de détail : \(nbr)"
        } else {
            activityTimeLabel.text = "Aucun temps pour cette activité"
        }
        
        activityImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageView_Click))
        activityImageView.addGestureRecognizer(tap)
        toggleButton.addGestureRecognizer(tap)
        
        if timeScoreActivity.running {
            activityStatusLabel.text = "En cours"
        } else {
            activityStatusLabel.text = ""
        }
    }
    
    @objc func imageView_Click() {
        if timeScoreActivity.running {
            if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: false, userConnected: userConnected!) {
                activityStatusLabel.text = ""
            }
        } else {
            if TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: timeScoreActivity!, running: true, userConnected: userConnected!) {
                activityStatusLabel.text = "En cours"
            }
        }
        NotificationCenter.default.post(name: .changeRunningStatusInTimeScoreActivity, object: self, userInfo: ["timeScoreActivity": timeScoreActivity])
    }
}
