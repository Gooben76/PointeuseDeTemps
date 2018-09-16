//
//  DayTableCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 9/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class DayTableCell: UITableViewCell {

    @IBOutlet weak var typicalDayNameLabel: UILabel!
    @IBOutlet weak var numberOfActivitiesLabel: UILabel!
    
    var typicalDay: TypicalDays!
    var userConnected: Users!
    
    func initCell(typicalDay: TypicalDays, userConnected: Users) {
        self.typicalDay = typicalDay
        self.userConnected = userConnected
        
        typicalDayNameLabel.text = typicalDay.typicalDayName
        let nbr = typicalDay.typicalDayActivities?.allObjects.count
        numberOfActivitiesLabel.text = RSC_NUMBER_OF_ACTIVITIES + String(nbr!)
    }
}
