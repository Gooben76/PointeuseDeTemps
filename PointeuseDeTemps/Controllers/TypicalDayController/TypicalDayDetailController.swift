//
//  TypicalDayDetailController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 9/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class TypicalDayDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var saveButton: ButtonTS!
    @IBOutlet weak var typicalDayTF: TextFieldTS!
    @IBOutlet weak var numberOfActivitiesLabel: LabelH3TitleTS!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleActivitiesLabel: LabelH2TS!
    
    var typicalDay: TypicalDays?
    var newData:Bool = false
    var userConnected: Users?
    var typicalDayActivitiesDetails: [TypicalDayActivitiesDetails] = [TypicalDayActivitiesDetails]()
    
    let cellID = "TypicalDayDetailTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //keyboardManagement()
        
        typicalDayTF.placeholder = RSC_TYPICAL_DAY
        saveButton.setTitle(RSC_SAVE, for: .normal)
        saveButton.isHidden = true
        titleActivitiesLabel.text = RSC_LISTOFACTIVITIES
        
        if let nav = navigationController {
            let navigationBar = nav.navigationBar
            navigationBar.tintColor = UIColor.black
        }
            
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
        tableView.delegate = self
        tableView.dataSource = self
        typicalDayTF.delegate = self
        
        if typicalDay != nil {
            tableView.isHidden = false
            titleActivitiesLabel.isHidden = false
            typicalDayTF.text = typicalDay!.typicalDayName
            let nbr = typicalDay?.typicalDayActivities?.allObjects.count
            numberOfActivitiesLabel.text = RSC_NUMBER_OF_ACTIVITIES + String(nbr!)
            if let detailsData = TypicalDayActivitiesDataHelpers.getFunc.getAllTypicalDayActivitiesDetailsForTypicalDay(typicalDay: typicalDay!, userConnected: userConnected!) {
                typicalDayActivitiesDetails = detailsData
            }
        } else {
            if newData {
                typicalDayTF.text = ""
                numberOfActivitiesLabel.text = RSC_NUMBER_OF_ACTIVITIES + "0"
                tableView.isHidden = true
                saveButton.isHidden = false
                titleActivitiesLabel.isHidden = true
            }
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(handler_DetailUpdate), name: .numberActivitiesInTypicalDay, object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typicalDayActivitiesDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? TypicalDayDetailTableCell {
            cell.initCell(typicalDayActivityDetail: typicalDayActivitiesDetails[indexPath.row], typicalDay: typicalDay!, userConnected: userConnected!)
            return cell
        }
        return UITableViewCell()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == typicalDayTF {
            if let text = textField.text, text != "" {
                typicalDay!.typicalDayName = text
                if !TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: typicalDay!, userConnected: userConnected!) {
                    print("Erreur de sauvegarde de la journée type")
                }
            }
        }
    }
    
    @objc func handler_DetailUpdate(notification: Notification) {
        let nbr = typicalDay?.typicalDayActivities?.allObjects.count
        numberOfActivitiesLabel.text = RSC_NUMBER_OF_ACTIVITIES + String(nbr!)
    }
    
    @IBAction func saveButton_Click(_ sender: Any) {
        if let text = typicalDayTF.text, text != "" {
            if newData {
                if TypicalDaysDataHelpers.getFunc.setNewTypicalDay(typicalDayName: text, userConnected: userConnected!) {
                    let typicalDay: TypicalDays! = TypicalDaysDataHelpers.getFunc.searchTypicalDayByName(typicalDayName: text, userConnected: userConnected)
                    self.typicalDay = typicalDay
                    if let detailsData = TypicalDayActivitiesDataHelpers.getFunc.getAllTypicalDayActivitiesDetailsForTypicalDay(typicalDay: typicalDay, userConnected: userConnected!) {
                        typicalDayActivitiesDetails = detailsData
                    }
                    let nbr = typicalDay?.typicalDayActivities?.allObjects.count
                    numberOfActivitiesLabel.text = RSC_NUMBER_OF_ACTIVITIES + String(nbr!)
                    tableView.isHidden = false
                    tableView.reloadData()
                    saveButton.isHidden = true
                    titleActivitiesLabel.isHidden = false
                    //self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                typicalDay!.typicalDayName = text
                if TypicalDaysDataHelpers.getFunc.setTypicalDay(typicalDay: typicalDay!, userConnected: userConnected!) {
                    Alert.show.success(message: RSC_SAVE_OK, controller: self)
                }
            }
        }
        hideKeyboard()
    }
}
