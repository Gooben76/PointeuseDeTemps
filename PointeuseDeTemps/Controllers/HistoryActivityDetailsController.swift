//
//  HistoryActivityDetailsController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 4/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class HistoryActivityDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dateLabel: LabelH1TS!
    @IBOutlet weak var activityLabel: LabelH1TS!
    @IBOutlet weak var tableView: UITableView!
    
    var timeScoreActivity: TimeScoreActivities?
    var userConnected: Users?
    
    let cellID = "HistoryTimeScoreActivityDetailTableCell"
    
    var timeScoreActivityDetails = [TimeScoreActivityDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = RSC_ACTIVITYDETAILS
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
        if timeScoreActivity != nil && userConnected != nil {
            dateLabel.text = DateHelper.getFunc.convertDateToString(timeScoreActivity!.timeScoreId!.date!)
            activityLabel.text = timeScoreActivity?.activityId?.activityName
            
            if let allData = TimeScoreActivityDetailsDataHelpers.getFunc.getTimeScoreActivityDetailssForATimeScoreActivity(timeScoreActivity: timeScoreActivity!, userConnected: userConnected!) {
                timeScoreActivityDetails = allData
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeScoreActivityDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? HistoryTimeScoreActivityDetailTableCell {
            cell.initCell(timeScoreActivityDetail: timeScoreActivityDetails[indexPath.row], userConnected: userConnected!)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if timeScoreActivityDetails[indexPath.row].startLatitude != 0 && timeScoreActivityDetails[indexPath.row].startLongitude != 0 &&
            timeScoreActivityDetails[indexPath.row].endLatitude != 0 &&
            timeScoreActivityDetails[indexPath.row].endLongitude != 0 {
            let controller = MapControllerViewController()
            controller.detail = timeScoreActivityDetails[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
