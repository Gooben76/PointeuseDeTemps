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
    @IBOutlet weak var latitudeStartTitleLabel: LabelH3TitleTS!
    @IBOutlet weak var latitudeStartLabel: LabelH3TS!
    @IBOutlet weak var longitudeStartTitleLabel: LabelH3TitleTS!
    @IBOutlet weak var longitudeStartLabel: LabelH3TS!
    @IBOutlet weak var endDateTitleLabel: LabelH3TitleTS!
    @IBOutlet weak var endDateLabel: LabelH3TS!
    @IBOutlet weak var latitudeEndTitleLabel: LabelH3TitleTS!
    @IBOutlet weak var latitudeEndLabel: LabelH3TS!
    @IBOutlet weak var longitudeEndTitleLabel: LabelH3TitleTS!
    @IBOutlet weak var longitudeEndLabel: LabelH3TS!
    @IBOutlet weak var durationTitleLabel: LabelH3TitleTS!
    @IBOutlet weak var durationLabel: LabelH3TitleTS!
    
    var timeScoreActivityDetail : TimeScoreActivityDetails!
    var userConnected: Users!
    
    func initCell(timeScoreActivityDetail: TimeScoreActivityDetails, userConnected: Users) {
        self.timeScoreActivityDetail = timeScoreActivityDetail
        self.userConnected = userConnected
        
        startDateTitleLabel.text = RSC_START
        latitudeStartTitleLabel.text = RSC_LATITUDE
        longitudeStartTitleLabel.text = RSC_LONGITUDE
        endDateTitleLabel.text = RSC_END
        latitudeEndTitleLabel.text = RSC_LATITUDE
        longitudeEndTitleLabel.text = RSC_LONGITUDE
        durationTitleLabel.text = RSC_DURATION
        
        startDateLabel.text = DateHelper.getFunc.convertDateTimeToString(timeScoreActivityDetail.startDateTime!)
        latitudeStartLabel.text = ""
        longitudeStartLabel.text = ""
        if timeScoreActivityDetail.startLatitude != 0 {
            latitudeStartLabel.text = String(timeScoreActivityDetail.startLatitude)
        }
        if timeScoreActivityDetail.startLongitude != 0 {
            longitudeStartLabel.text = String(timeScoreActivityDetail.startLongitude)
        }
        
        if timeScoreActivityDetail.endDateTime != nil {
            endDateLabel.text = DateHelper.getFunc.convertDateTimeToString(timeScoreActivityDetail.endDateTime!)
            latitudeEndLabel.text = ""
            longitudeEndLabel.text = ""
            durationLabel.text = DateHelper.getFunc.getDurationFromDouble(duration: timeScoreActivityDetail.duration)
            if timeScoreActivityDetail.endLatitude != 0 {
                latitudeEndLabel.text = String(timeScoreActivityDetail.endLatitude)
            }
            if timeScoreActivityDetail.endLongitude != 0 {
                longitudeEndLabel.text = String(timeScoreActivityDetail.endLongitude)
            }
        } else {
            endDateLabel.text = ""
            latitudeEndLabel.text = ""
            longitudeEndLabel.text = ""
            durationLabel.text = ""
        }
    }
    
}
