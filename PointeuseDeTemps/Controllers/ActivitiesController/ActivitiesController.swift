//
//  ActivitiesController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 13/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ActivitiesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var navigationBar: UINavigationBar?
    
    var activities = [Activities]()
    var imagePicker: UIImagePickerController?
    var currentTapIndex: Int = -1
    var userConnected: Users?
    
    let cellID = "ActivityTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = navigationController {
            navigationBar = nav.navigationBar
            navigationBar!.items![0].title = RSC_ACTIVITIES
            
            let rightAddBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "add-16px"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(addButtonAction))
            rightAddBarButtonItem.tintColor = UIColor.black
            self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
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
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handler_ErrorMessageToShow), name: .showErrorMessageInActivitiesController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handler_RefreshData), name: .refreshActivitiesController, object: nil)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        if let allData = ActivitiesDataHelpers.getFunc.getAllActivities(userConnected: userConnected!) {
            activities = allData
        }
        tableView.reloadData()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? ActivityTableCell {
            cell.initCell(activity: activities[indexPath.row], userConnected: userConnected!)
            if cell.imageActivity.gestureRecognizers?.count ?? 0 == 0 {
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageClick(sender: )))
                cell.imageActivity.addGestureRecognizer(tap)
                cell.imageActivity.isUserInteractionEnabled = true
            }
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
            if ActivitiesDataHelpers.getFunc.delActivity(activity: activities[indexPath.row]) {
                activities.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    @objc func addButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: RSC_ACTIVITIES_MANAGEMENT, message: RSC_ADD, preferredStyle: .alert)
        let add = UIAlertAction(title: RSC_OK, style: .default) { (action) in
            let textFieldAlert = alert.textFields![0] as UITextField
            if let text = textFieldAlert.text, text != "" {
                if ActivitiesDataHelpers.getFunc.setNewActivity(activityName: text, userConnected: self.userConnected!) {
                    if let allData = ActivitiesDataHelpers.getFunc.getAllActivities(userConnected: self.userConnected!) {
                        self.activities = allData
                        self.tableView.reloadData()
                    }
                }
            }
        }
        alert.addTextField { (tf) in
            tf.placeholder = RSC_ACTIVITYNAME
        }
        let cancel = UIAlertAction(title: RSC_CANCEL, style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handler_ErrorMessageToShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let message = userInfo["message"] as? String {
                Alert.show.error(message: message, controller: self)
            }
        }
    }
    
    @objc func handler_RefreshData(notification: Notification) {
        loadData()
    }
}
