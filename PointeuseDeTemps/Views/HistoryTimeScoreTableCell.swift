//
//  HistoryTimeScoreTableCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 4/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class HistoryTimeScoreTableCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    var timeScore : TimeScores!
    var userConnected: Users!
    
    func initCell(timeScore: TimeScores, userConnected: Users) {
        self.timeScore = timeScore
        self.userConnected = userConnected
        
        dateLabel.text = DateHelper.getFunc.convertDateToString(timeScore.date!)
    }
    
}
