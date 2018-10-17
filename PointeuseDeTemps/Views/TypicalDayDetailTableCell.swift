//
//  TypicalDayDetailTableCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 16/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class TypicalDayDetailTableCell: UITableViewCell {

    @IBOutlet weak var activityLabel: LabelH2TS!
    @IBOutlet weak var selectedSwitch: UISwitch!
    
    var typicalDay: TypicalDays!
    var typicalDayActivityDetail: TypicalDayActivitiesDetails!
    var userConnected: Users!
    
    func initCell(typicalDayActivityDetail: TypicalDayActivitiesDetails, typicalDay: TypicalDays, userConnected: Users) {
        self.typicalDayActivityDetail = typicalDayActivityDetail
        self.userConnected = userConnected
        self.typicalDay = typicalDay
        
        activityLabel.text = typicalDayActivityDetail.activity.activityName
        selectedSwitch.isOn = typicalDayActivityDetail.selected
        
        selectedSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
    }

    @objc func switchValueDidChange(sender: UISwitch!) {
        if sender.isOn {
            if let elmfound = TypicalDayActivitiesDataHelpers.getFunc.searchTypicalDayActivityByTypicalDayAndActivity(typicalDay: typicalDay, activity: typicalDayActivityDetail.activity, userConnected: userConnected) {
                if !TypicalDayActivitiesDataHelpers.getFunc.setTypicalDayActivity(typicalDay: typicalDay, activity: typicalDayActivityDetail.activity, userConnected: userConnected) {
                    print("Erreur à la sauvegarde de TypicalDayActivities")
                }
            } else {
                if !TypicalDayActivitiesDataHelpers.getFunc.setNewTypicalDayActivity(typicalDay: typicalDay, activity: typicalDayActivityDetail.activity, userConnected: userConnected) {
                    print("Erreur à la création de TypicalDayActivities")
                }
            }
        } else {
            if let elmfound = TypicalDayActivitiesDataHelpers.getFunc.searchTypicalDayActivityByTypicalDayAndActivity(typicalDay: typicalDay, activity: typicalDayActivityDetail.activity, userConnected: userConnected) {
                if !TypicalDayActivitiesDataHelpers.getFunc.delTypicalDayActivity(typicalDayActivity: elmfound) {
                    print("Erreur à la suppression de TypicalDayActivities")
                }
            }
        }
        
        NotificationCenter.default.post(name: .numberActivitiesInTypicalDay, object: self)
    }
}
