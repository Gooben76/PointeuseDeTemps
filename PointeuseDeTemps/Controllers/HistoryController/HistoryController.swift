//
//  HistoryController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 14/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "HistoryTimeScoreTableCell"
    
    var navigationBar: UINavigationBar?
    
    var timeScores = [TimeScores]()
    var userConnected: Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //keyboardManagementInTableView()
        
        if let nav = navigationController {
            navigationBar = nav.navigationBar
            navigationBar!.items![0].title = RSC_HISTORY
            let parameterBarButtonItem = UIBarButtonItem(image: UIImage(named: "user-30"), style: UIBarButtonItemStyle.done, target: self, action: #selector(parameterButtonAction))
            parameterBarButtonItem.tintColor = UIColor.black
            self.navigationItem.setLeftBarButtonItems([parameterBarButtonItem], animated: true)
        }
        
        let usr = UserDefaults.standard.object(forKey: "connectedUser")
        if usr != nil, let login = usr as? String {
            if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login) {
                userConnected = user
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let allData = TimeScoresDataHelpers.getFunc.getAllTimeScores(userConnected: userConnected!) {
            timeScores = allData
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeScores.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? HistoryTimeScoreTableCell {
            cell.initCell(timeScore: timeScores[indexPath.row], userConnected: userConnected!)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = HistoryActivitiesController()
        controller.timeScore = timeScores[indexPath.row]
        controller.userConnected = userConnected!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func parameterButtonAction() {
        if userConnected != nil {
            self.navigationController?.pushViewController(ParametersController(), animated: true)
        }
    }
    
    
}
