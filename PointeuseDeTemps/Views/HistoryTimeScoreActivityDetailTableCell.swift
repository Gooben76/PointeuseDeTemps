//
//  HistoryTimeScoreActivityDetailTableCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 4/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class HistoryTimeScoreActivityDetailTableCell: UITableViewCell {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    var timeScoreActivityDetail : TimeScoreActivityDetails!
    var userConnected: Users!
    
    func initCell(timeScoreActivityDetail: TimeScoreActivityDetails, userConnected: Users) {
        self.timeScoreActivityDetail = timeScoreActivityDetail
        self.userConnected = userConnected
        
        startDateLabel.text = DateHelper.getFunc.convertDateTimeToString(timeScoreActivityDetail.startDateTime!)
        if timeScoreActivityDetail.endDateTime != nil {
            endDateLabel.text = DateHelper.getFunc.convertDateTimeToString(timeScoreActivityDetail.endDateTime!)
        }
    }
    
}
