//
//  TimeScoresControllerExtension2.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 23/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

extension TimeScoresController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if timeScoreActivities != nil {
            return timeScoreActivities!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? TimeScoreActivityTableCell {
            cell.initCell(timeScoreActivity: timeScoreActivities![indexPath.row], timeScore: timeScore!, userConnected: userConnected!)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if TimeScoreActivitiesDataHelpers.getFunc.delTimeScoreActivity(timeScoreActivity: timeScoreActivities![indexPath.row]) {
                timeScoreActivities!.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    @objc func handler_DetailUpdate(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let selectedActivity = userInfo["timeScoreActivity"] as? TimeScoreActivities {
                let finded = timeScoreActivities!.filter {$0 != selectedActivity}
                if finded.count > 0 {
                    for elm: TimeScoreActivities in finded {
                        if !TimeScoreActivitiesDataHelpers.getFunc.setTimeScoreActivityRunning(timeScoreActivity: elm, running: false, coordinates: nil, userConnected: userConnected!) {
                            print("Erreur à la sauvegarde TimeScoreActivities")
                        }
                    }
                    loadTableView()
                }
            }
        }
    }
}
