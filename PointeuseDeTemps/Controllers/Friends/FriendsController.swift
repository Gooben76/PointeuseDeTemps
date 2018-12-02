//
//  FriendsController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 02/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var navigationBar: UINavigationBar?
    
    let cellID = "FriendTableCell"
    
    var friends = [Friends]()
    var userConnected: Users?
    
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let allData = FriendsDataHelpers.getFunc.getAllFriends(userConnected: userConnected!) {
            friends = allData
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? FriendTableCell {
            cell.initCell(friend: friends[indexPath.row], userConnected: userConnected!)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    @objc func addButtonAction(_sender: Any) {
        
    }
    
}
