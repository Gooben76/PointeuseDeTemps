//
//  HistoryTimeScoreActivityTableCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 4/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class HistoryTimeScoreActivityTableCell: UITableViewCell {

    @IBOutlet weak var activityLabel: UILabel!
    
    var timeScoreActivity : TimeScoreActivities!
    var userConnected: Users!
    
    func initCell(timeScoreActivity: TimeScoreActivities, userConnected: Users) {
        self.timeScoreActivity = timeScoreActivity
        self.userConnected = userConnected
        
        activityLabel.text = timeScoreActivity.activityId!.activityName!
    }
    
}
