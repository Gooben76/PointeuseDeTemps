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
    @IBOutlet weak var blurVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var popupView: PickerViewSelection!
    @IBOutlet weak var popTitleLabel: LabelH2TitleTS!
    @IBOutlet weak var popSaveButton: ButtonTS!
    @IBOutlet weak var popPickerView: UIPickerView!
    
    var navigationBar: UINavigationBar?
    
    let cellID = "FriendTableCell"
    
    var friends = [Friends]()
    
    var userConnected: Users?
    var userForNewMessages = [UserAPI]()
    var selectedPickerView: UserAPI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //keyboardManagementInTableView()
        
        if let nav = navigationController {
            navigationBar = nav.navigationBar
            navigationBar!.items![0].title = RSC_FRIENDS
            
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
                userConnected = user
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
        self.blurVisualEffectView.alpha = 0
        self.popupView.alpha = 0
        
        initPickerView()
        
        blurVisualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidePopup)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataNewMessageForTheFriend), name: .newMessageForAFriendFriend, object: nil)
    }

    @objc func dataNewMessageForTheFriend(notification: NSNotification) {
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        if let allData = FriendsDataHelpers.getFunc.getAllFriendsFromMessages(userConnected: userConnected!) {
            friends = allData
        }
        sortFriends()
    }
    
    func sortFriends() {
        if friends.count > 0 {
            friends = friends.sorted(by: { $0.user.login! < $1.user.login!})
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let indexPath = IndexPath(item: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? FriendTableCell {
            cell.initCell(friend: friends[indexPath.row], userConnected: userConnected!)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if FriendsDataHelpers.getFunc.deleteAllMessagesFromAndToAFriend(friend: friends[indexPath.row], userConnected: userConnected!) {
                friends.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = MessagesController()
        controller.friend = friends[indexPath.row].user
        controller.userConnected = userConnected!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showPopup() {
        popTitleLabel.text = RSC_SELECTIONOFUSER
        popSaveButton.setTitle(RSC_ADD, for: .normal)
        
        userForNewMessages.removeAll()
        userForNewMessages.append(UserAPI(intId: 0))
        if usersForMessages.count > 0 {
            for usr in usersForMessages {
                if !friends.contains(where: {$0.user.id == usr.id}) {
                    userForNewMessages.append(usr)
                }
            }
        }
        popPickerView.reloadAllComponents()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blurVisualEffectView.alpha = 1
            self.popupView.alpha = 1
        }) { (success) in
            //
        }
    }
    
    @IBAction func popSaveButton_Click(_ sender: Any) {
        if selectedPickerView != nil {
            if !friends.contains(where: {$0.user.id == Int32(selectedPickerView!.id)}) {
                var search = UsersDataHelpers.getFunc.searchUserById(id: Int32(selectedPickerView!.id))
                if search != nil {
                    friends.append(Friends(user: search!, active: search!.allowMessages))
                } else {
                    if UsersDataHelpers.getFunc.setNewUserFromUserAPI(userAPI: selectedPickerView!) {
                        search = UsersDataHelpers.getFunc.searchUserById(id: Int32(selectedPickerView!.id))
                        if search != nil {
                            friends.append(Friends(user: search!, active: search!.allowMessages))
                        }
                    }
                }
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blurVisualEffectView.alpha = 0
            self.popupView.alpha = 0
        }) { (success) in
            
        }
        tableView.reloadData()
    }
    
    @objc func addButtonAction(_sender: Any) {
        showPopup()
    }
    
    @objc func hidePopup() {
        if self.popupView.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.blurVisualEffectView.alpha = 0
                self.popupView.alpha = 0
            }) { (success) in
                
            }
        }
    }
    
    @objc func parameterButtonAction() {
        if userConnected != nil {
            self.navigationController?.pushViewController(ParametersController(), animated: true)
        }
    }
}
