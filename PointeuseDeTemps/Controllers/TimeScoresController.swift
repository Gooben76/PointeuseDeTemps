//
//  TimeScoresController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 13/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class TimeScoresController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typicalDayPicker: UIPickerView!
    @IBOutlet weak var saveButton: ButtonTS!
    
    var navigationBar: UINavigationBar?
    
    var typicalDayNames : [String]?
    var typicalDay: TypicalDays?
    var userConnected: Users?
    var timeScore: TimeScores?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.setTitle(RSC_SAVE, for: .normal)
        
        if let nav = navigationController {
            navigationBar = nav.navigationBar
            navigationBar!.items![0].title = RSC_TIMESCORE
        }
        
        let usr = UserDefaults.standard.object(forKey: "connectedUser")
        if usr != nil, let login = usr as? String {
            if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login), user != nil {
                userConnected = user
            }
        }
        
        initPickerView()
        
        if let allData = TimeScoresDataHelpers.getFunc.getAllTimeScores(userConnected: userConnected!) {
            /*if allData.count == 1 {
                if !TimeScoresDataHelpers.getFunc.delTimeScore(timeScore: allData[0]) {
                    
                }
            }*/
            print("Données pointage : \(allData.count)")
            if allData.count == 1 {
                print("Date : \(DateHelper.getFunc.convertDateToString(allData[0].date!))")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveButton.isHidden = true
        typicalDayPicker.isUserInteractionEnabled = false
        
        dateLabel.text = DateHelper.getFunc.convertDateToString(Date())
        let dateToday = DateHelper.getFunc.convertStringDateToDate(dateLabel.text!)
        
        if timeScore != nil {
            print("Pas null")
            if dateToday != timeScore!.date {
                timeScore = nil
                saveButton.isHidden = false
                typicalDayPicker.isUserInteractionEnabled = true
            } else {
                saveButton.isHidden = true
                typicalDayPicker.isUserInteractionEnabled = false
                
                // Ajouter la sélection du picker
            }
        } else {
            if let data = TimeScoresDataHelpers.getFunc.searchTimeScoreByDate(date: dateToday!, userConnected: userConnected!) {
                    print("Trouvé")
                    timeScore = data
                    saveButton.isHidden = true
                    typicalDayPicker.isUserInteractionEnabled = false
                    // Ajouter la sélection du picker
            }
        }
        
        if timeScore == nil {
            print("Pas trouvé")
            saveButton.isHidden = false
            typicalDayPicker.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func saveButton_Click(_ sender: Any) {
        print("Date : \(dateLabel.text!)")
        if typicalDay == nil {
            print("TypicalDay : ")
        } else {
            print("TypicalDay : \(typicalDay!.typicalDayName!)")
        }
        
        let date = DateHelper.getFunc.convertStringDateToDate(dateLabel.text!)
        if TimeScoresDataHelpers.getFunc.setNewTimeScore(date: date!, typicalDay: typicalDay, userConnected: userConnected!) {
            if let data = TimeScoresDataHelpers.getFunc.searchTimeScoreByDate(date: date!, userConnected: userConnected!) {
                timeScore = data
                saveButton.isHidden = true
                typicalDayPicker.isUserInteractionEnabled = false
            }
        }
    }
    
}
