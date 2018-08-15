//
//  ActivitiesController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 13/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ActivitiesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addButton: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var activities = [Activities]()
    let cellID = "ActivityTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
        activities = ActivitiesDataHelpers.getFunc.getAllActivities()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? ActivityTableCell {
            cell.initCell(activity: activities[indexPath.row])
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
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("Edit")
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: RSC_ACTIVITIES_MANAGEMENT, message: RSC_ADD, preferredStyle: .alert)
        let add = UIAlertAction(title: RSC_OK, style: .default) { (action) in
            let textFieldAlert = alert.textFields![0] as UITextField
            if let text = textFieldAlert.text, text != "" {
                if ActivitiesDataHelpers.getFunc.setNewActivity(activityName: text) {
                    self.activities = ActivitiesDataHelpers.getFunc.getAllActivities()
                    self.tableView.reloadData()
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
}
