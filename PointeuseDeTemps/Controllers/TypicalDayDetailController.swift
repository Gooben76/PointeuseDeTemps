//
//  TypicalDayDetailController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 9/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class TypicalDayDetailController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var typicalDayTF: TextFieldTS!
    @IBOutlet weak var numberOfActivitiesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var typicalDay: TypicalDays?
    var newData:Bool = false
    var userConnected: Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typicalDayTF.placeholder = RSC_TYPICAL_DAY
        saveButton.setTitle(RSC_SAVE, for: .normal)
        
        if typicalDay != nil {
            tableView.isHidden = false
            typicalDayTF.text = typicalDay!.typicalDayName
            numberOfActivitiesLabel.text = RSC_NUMBER_OF_ACTIVITIES
        } else {
            if newData {
                typicalDayTF.text = ""
                numberOfActivitiesLabel.text = RSC_NUMBER_OF_ACTIVITIES + "0"
                tableView.isHidden = true
            }
        }
    }

    @IBAction func saveButton_Click(_ sender: Any) {
        if let text = typicalDayTF.text, text != "" {
            if newData {
                if TypicalDaysDataHelpers.getFunc.setNewTypicalDay(typicalDayName: text, userConnected: userConnected!) {
                    let controller = DaysController()
                    controller.dataToRefresh = true
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
}
