//
//  DaysController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 14/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class DaysController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var daysTableView: UITableView!
    
    let cellID = "DayTableCell"
    
    var navigationBar: UINavigationBar?
    
    var typicalDays = [TypicalDays]()
    var userConnected: Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardManagementInTableView()
        
        if let nav = navigationController {
            navigationBar = nav.navigationBar
            navigationBar!.items![0].title = RSC_DAYS
            
            let rightAddBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "add-16px"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(addButtonAction))
            rightAddBarButtonItem.tintColor = UIColor.black
            self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
            let parameterBarButtonItem = UIBarButtonItem(image: UIImage(named: "user-30"), style: UIBarButtonItemStyle.done, target: self, action: #selector(parameterButtonAction))
            parameterBarButtonItem.tintColor = UIColor.black
            self.navigationItem.setLeftBarButtonItems([parameterBarButtonItem], animated: true)
        }
        
        let usr = UserDefaults.standard.object(forKey: "connectedUser")
        if usr != nil, let login = usr as? String {
            if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login) {
                print("User OK  for day")
                userConnected = user
            }
        }
        
        daysTableView.delegate = self
        daysTableView.dataSource = self
        
        let nib = UINib(nibName: cellID, bundle: nil)
        daysTableView.register(nib, forCellReuseIdentifier: cellID)
        
        if let allData = TypicalDaysDataHelpers.getFunc.getAllTypicalDays(userConnected: userConnected) {
            typicalDays = allData
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let allData = TypicalDaysDataHelpers.getFunc.getAllTypicalDays(userConnected: userConnected) {
            typicalDays = allData
            daysTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typicalDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = daysTableView.dequeueReusableCell(withIdentifier: cellID) as? DayTableCell {
            cell.initCell(typicalDay: typicalDays[indexPath.row], userConnected: userConnected!)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                if TypicalDaysDataHelpers.getFunc.delTypicalDay(typicalDay: typicalDays[indexPath.row], userConnected: userConnected!) {
                    typicalDays.remove(at: indexPath.row)
                    self.daysTableView.deleteRows(at: [indexPath], with: .fade)
                }
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = TypicalDayDetailController()
        controller.newData = false
        controller.userConnected = userConnected!
        controller.typicalDay = typicalDays[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func addButtonAction(_ sender: Any) {
        let controller = TypicalDayDetailController()
        controller.newData = true
        controller.userConnected = userConnected!
        controller.typicalDay = nil
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func parameterButtonAction() {
        if userConnected != nil {
            self.navigationController?.pushViewController(ParametersController(), animated: true)
        }
    }
    
}
