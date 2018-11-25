//
//  HistoryTimeScoreActivityDetailTableCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 4/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class HistoryTimeScoreActivityDetailTableCell: UITableViewCell {

    @IBOutlet weak var startDateTitleLabel: LabelH3TitleTS!
    @IBOutlet weak var startDateLabel: LabelH3TS!
    @IBOutlet weak var endDateTitleLabel: LabelH3TitleTS!
    @IBOutlet weak var endDateLabel: LabelH3TS!
    @IBOutlet weak var durationTitleLabel: LabelH3TitleTS!
    @IBOutlet weak var durationLabel: LabelH3TitleTS!
    
    var timeScoreActivityDetail : TimeScoreActivityDetails!
    var userConnected: Users!
    
    func initCell(timeScoreActivityDetail: TimeScoreActivityDetails, userConnected: Users) {
        self.timeScoreActivityDetail = timeScoreActivityDetail
        self.userConnected = userConnected
        
        startDateTitleLabel.text = RSC_START
        endDateTitleLabel.text = RSC_END
        durationTitleLabel.text = RSC_DURATION
        
        startDateLabel.text = DateHelper.getFunc.convertDateTimeToString(timeScoreActivityDetail.startDateTime!)
        
        if timeScoreActivityDetail.endDateTime != nil {
            endDateLabel.text = DateHelper.getFunc.convertDateTimeToString(timeScoreActivityDetail.endDateTime!)
            durationLabel.text = DateHelper.getFunc.getDurationFromDouble(duration: timeScoreActivityDetail.duration)
        } else {
            endDateLabel.text = ""
            durationLabel.text = ""
        }
    }
    
}
