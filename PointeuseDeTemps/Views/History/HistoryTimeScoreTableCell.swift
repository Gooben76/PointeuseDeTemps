//
//  HistoryTimeScoreTableCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 4/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class HistoryTimeScoreTableCell: UITableViewCell {

    @IBOutlet weak var dateLabel: LabelH2BoldTS!
    @IBOutlet weak var durationLabel: LabelH3TS!
    
    var timeScore : TimeScores!
    var userConnected: Users!
    
    func initCell(timeScore: TimeScores, userConnected: Users) {
        self.timeScore = timeScore
        self.userConnected = userConnected
        
        dateLabel.text = DateHelper.getFunc.convertDateToString(timeScore.date!)
        
        var totalDuration: Double = 0
        for elm in timeScore.timeScoreActivities!.allObjects {
            if let element = elm as? TimeScoreActivities {
                for elm2 in element.timeScoreActivityDetails!.allObjects {
                    if let element2 = elm2 as? TimeScoreActivityDetails {
                        if element2.startDateTime != nil && element2.endDateTime != nil {
                            totalDuration += element2.duration
                        }
                    }
                
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
