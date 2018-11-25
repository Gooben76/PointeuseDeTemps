//
//  TimeScoresController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 13/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit
import MapKit

class TimeScoresController: UIViewController {
    
    @IBOutlet weak var dateLabel: LabelH1TS!
    @IBOutlet weak var typicalDayTF: TextFieldTS!
    @IBOutlet weak var saveButton: ButtonTS!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actvititiesLabel: UILabel!
    
    @IBOutlet weak var blurVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var popupView: PickerViewSelection!
    @IBOutlet weak var popTitleLabel: UILabel!
    @IBOutlet weak var popSaveButton: ButtonTS!
    @IBOutlet weak var popPickerView: UIPickerView!
    
    var navigationBar: UINavigationBar?
    var rightAddBarButtonItem: UIBarButtonItem?
    var leftAddBarButtonItem: UIBarButtonItem?
    
    var pickerViewNames: [String] = [String]()
    var pickerViewData: Int = 0
    var userConnected: Users?
    var timeScore: TimeScores?
    var timeScoreActivities : [TimeScoreActivities]?
    var selectedRowPickerView : String = ""

    let cellID = "TimeScoreActivityTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.setTitle(RSC_SAVE, for: .normal)
        actvititiesLabel.text = RSC_LISTOFACTIVITIES
        
        if let nav = navigationController {
            navigationBar = nav.navigationBar
            navigationBar!.items![0].title = RSC_TIMESCORE
            
            rightAddBarButtonItem = UIBarButtonItem(image: UIImage(named: "add-16px"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(addButtonAction))
            rightAddBarButtonItem!.tintColor = UIColor.black
            self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem!], animated: true)
            leftAddBarButtonItem = UIBarButtonItem(image: UIImage(named: "del-16px"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(delButtonAction))
            leftAddBarButtonItem!.tintColor = UIColor.black
            //let apiBarButtonItem = UIBarButtonItem(title: "API", style: UIBarButtonItemStyle.done, target: self, action: #selector(apiButtonAction))
            //self.navigationItem.setLeftBarButtonItems([leftAddBarButtonItem!, apiBarButtonItem], animated: true)
        }
        
        let usr = UserDefaults.standard.object(forKey: "connectedUser")
        if usr != nil, let login = usr as? String {
            if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login) {
                userConnected = user
            }
        }
        
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(typicalDayTF_Click))
        typicalDayTF.addGestureRecognizer(tap)
        typicalDayTF.isUserInteractionEnabled = true
        typicalDayTF.placeholder = RSC_TYPICAL_DAY
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initPickerView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handler_DetailUpdate), name: .changeRunningStatusInTimeScoreActivity, object: nil)
    }

    @objc func apiButtonAction() {
        if userConnected != nil {
            APIConnection.getFunc.getToken(login: userConnected!.login!, mail: userConnected!.mail!, password: userConnected!.password!) { (token) in
                if token.id > 0 {
                    print("Token : \(token.token)")
                    APIUsers.getFunc.getUserFromId(id: token.id, token: token.token, completion: { (userAPI) in
                        if userAPI != nil {
                            print("")
                        } else {
                            print("Pas de User")
                        }
                    })
                } else {
                    print("Pas de retour")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveButton.isHidden = true
        tableView.isHidden = false
        
        dateLabel.text = DateHelper.getFunc.convertDateToString(Date())
        let dateToday = DateHelper.getFunc.convertStringDateToDate(dateLabel.text!)
        
        if timeScore != nil {
            if dateToday != timeScore!.date {
                timeScore = nil
                saveButton.isHidden = false
                tableView.isHidden = true
                actvititiesLabel.isHidden = true
                rightAddBarButtonItem!.isEnabled = false
                leftAddBarButtonItem!.isEnabled = false
            } else {
                saveButton.isHidden = true
                tableView.isHidden = false
                actvititiesLabel.isHidden = false
                rightAddBarButtonItem!.isEnabled = true
                leftAddBarButtonItem!.isEnabled = true
                if timeScore!.typicalDayId != nil  {
                    typicalDayTF.text = timeScore!.typicalDayId!.typicalDayName!
                }
            }
        } else {
            if let data = TimeScoresDataHelpers.getFunc.searchTimeScoreByDate(date: dateToday!, userConnected: userConnected!) {
                timeScore = data
                saveButton.isHidden = true
                tableView.isHidden = false
                actvititiesLabel.isHidden = false
                rightAddBarButtonItem!.isEnabled = true
                leftAddBarButtonItem!.isEnabled = true
                if timeScore!.typicalDayId != nil  {
                    typicalDayTF.text = timeScore!.typicalDayId!.typicalDayName!
                }
            }
        }
        
        if timeScore == nil {
            saveButton.isHidden = false
            tableView.isHidden = true
            actvititiesLabel.isHidden = true
            rightAddBarButtonItem!.isEnabled = false
            leftAddBarButtonItem!.isEnabled = false
        } else {
            loadTableView()
        }
    }
    
    func loadTableView() {
        if timeScore != nil {
            let allData = TimeScoreActivitiesDataHelpers.getFunc.getTimeScoreActivitiesForATimeScore(timeScore: timeScore!, userConnected: userConnected!)
            timeScoreActivities = allData
            tableView.reloadData()
        }
    }
    
    @IBAction func saveButton_Click(_ sender: Any) {
        let date = DateHelper.getFunc.convertStringDateToDate(dateLabel.text!)
        var typicalDay: TypicalDays?
        if typicalDayTF.text != "" {
            typicalDay = TypicalDaysDataHelpers.getFunc.searchTypicalDayByName(typicalDayName: typicalDayTF.text!, userConnected: userConnected!)
        }
        if TimeScoresDataHelpers.getFunc.setNewTimeScore(date: date!, typicalDay: typicalDay, userConnected: userConnected!) {
            if let data = TimeScoresDataHelpers.getFunc.searchTimeScoreByDate(date: date!, userConnected: userConnected!) {
                timeScore = data
                saveButton.isHidden = true
                loadTableView()
                tableView.isHidden = false
                rightAddBarButtonItem!.isEnabled = true
                leftAddBarButtonItem!.isEnabled = true
                actvititiesLabel.isHidden = false
            }
        }
    }
    
    func showPopup() {
        switch pickerViewData {
            case 1 :
                popTitleLabel.text = RSC_SELECTIONOFTYPICALDAY
                pickerViewNames.removeAll()
                pickerViewNames.append("")
                if let allData = TypicalDaysDataHelpers.getFunc.getAllTypicalDays(userConnected: userConnected) {
                    for elm in allData {
                        pickerViewNames.append(elm.typicalDayName!)
                    }
                }
                popPickerView.reloadAllComponents()
                if typicalDayTF.text != "" {
                    let indexFinded = pickerViewNames.firstIndex(of: typicalDayTF.text!)
                    if indexFinded! > 0 {
                        popPickerView.selectRow(indexFinded!, inComponent: 0, animated: true)
                    }
                } else {
                    popPickerView.selectRow(0, inComponent: 0, animated: true)
                }
            case 2 :
                popTitleLabel.text = RSC_SELECTIONOFACTIVITY
                pickerViewNames.removeAll()
                pickerViewNames.append("")
                if let allData = ActivitiesDataHelpers.getFunc.getAllActivities(userConnected: userConnected) {
                    for elm in allData {
                        pickerViewNames.append(elm.activityName!)
                    }
                }
                if timeScoreActivities != nil {
                    for elm in timeScoreActivities! {
                        let activityName: String = elm.activityId!.activityName!
                        let indexFinded = pickerViewNames.firstIndex(of: activityName)
                        if indexFinded! > 0 {
                            pickerViewNames.remove(at: indexFinded!)
                        }
                    }
                }
                popPickerView.reloadAllComponents()
                popPickerView.selectRow(0, inComponent: 0, animated: true)
            default :
                break
        }
        
        popSaveButton.setTitle(RSC_ADD, for: .normal)
        UIView.animate(withDuration: 0.3, animations: {
            self.blurVisualEffectView.alpha = 1
            self.popupView.alpha = 1
        }) { (success) in
            //
        }
    }
    
    @objc func addButtonAction(_ sender: Any) {
        pickerViewData = 2
        showPopup()
    }
    
    @objc func delButtonAction(_ sender: Any) {
        if timeScore != nil {
            if TimeScoresDataHelpers.getFunc.delTimeScore(timeScore: timeScore, userConnected: userConnected!) {
                timeScore = nil
                typicalDayTF.text = ""
                Alert.show.success(message: RSC_DELETE_OK, controller: self)
                viewWillAppear(true)
            }
        }
    }
    
    @IBAction func popSaveButton_Click(_ sender: Any) {
        switch self.pickerViewData {
        case 1 :
            self.typicalDayTF.text = self.selectedRowPickerView
        case 2 :
            if self.selectedRowPickerView != "" && timeScore != nil {
                let activity = ActivitiesDataHelpers.getFunc.searchActivityByName(activityName: self.selectedRowPickerView, userConnected: userConnected!)
                if activity != nil {
                    if TimeScoreActivitiesDataHelpers.getFunc.setNewTimeScoreActivity(timeScore: timeScore!, activity: activity!, userConnected: userConnected!) {
                        loadTableView()
                    }
                }
            }
        default :
            break
        }
        self.selectedRowPickerView = ""
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blurVisualEffectView.alpha = 0
            self.popupView.alpha = 0
        }) { (success) in
            
        }
    }
    
    @objc func typicalDayTF_Click() {
        if !saveButton.isHidden {
            pickerViewData = 1
            showPopup()
        }
    }
}
