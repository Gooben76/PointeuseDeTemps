//
//  HistoryActivitiesController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 4/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class HistoryActivitiesController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var dateLabel: LabelH1TS!
    @IBOutlet weak var tableView: UITableView!
    
    var timeScore: TimeScores?
    var userConnected: Users?
    
    let cellID = "HistoryTimeScoreActivityTableCell"
    
    var timeScoreActivities = [TimeScoreActivities]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = RSC_ACTIVITIES
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
        if timeScore != nil && userConnected != nil {
            dateLabel.text = DateHelper.getFunc.convertDateToString(timeScore!.date!)
            
            if let allData = TimeScoreActivitiesDataHelpers.getFunc.getTimeScoreActivitiesForATimeScore(timeScore: timeScore!, userConnected: userConnected!) {
                timeScoreActivities = allData
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeScoreActivities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? HistoryTimeScoreActivityTableCell {
            cell.initCell(timeScoreActivity: timeScoreActivities[indexPath.row], userConnected: userConnected!)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = HistoryActivityDetailsController()
        controller.timeScoreActivity = timeScoreActivities[indexPath.row]
        controller.userConnected = userConnected!
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
