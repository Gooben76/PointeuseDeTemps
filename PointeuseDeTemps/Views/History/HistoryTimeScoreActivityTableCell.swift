//
//  HistoryTimeScoreActivityTableCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 4/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class HistoryTimeScoreActivityTableCell: UITableViewCell {

    @IBOutlet weak var activityLabel: LabelH2BoldTS!
    @IBOutlet weak var durationLabel: LabelH3TS!
    
    var timeScoreActivity : TimeScoreActivities!
    var userConnected: Users!
    
    func initCell(timeScoreActivity: TimeScoreActivities, userConnected: Users) {
        self.timeScoreActivity = timeScoreActivity
        self.userConnected = userConnected
        
        activityLabel.text = timeScoreActivity.activityId!.activityName!
        
        var totalDuration: Double = 0
        for elm in timeScoreActivity.timeScoreActivityDetails!.allObjects {
            if let element = elm as? TimeScoreActivityDetails {
                if element.startDateTime != nil && element.endDateTime != nil {
                    totalDuration += element.duration
                }
            }
        }
        if totalDuration > 0 {
            durationLabel.text = RSC_TOTALDURATION + "  " + DateHelper.getFunc.getDurationFromDouble(duration: totalDuration)
        } else {
            durationLabel.text = RSC_NODURATION
        }
    }
    
}
