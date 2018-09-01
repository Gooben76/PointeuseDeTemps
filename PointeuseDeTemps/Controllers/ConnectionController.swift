//
//  ConnectionController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 1/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ConnectionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let usr = UserDefaults.standard.object(forKey: "connectedUser")
        if usr != nil {
            print("user OK")
            let controller = TabBarController()
            self.present(controller, animated: true, completion: nil)
        } else {
            print("user not OK")
        }
    }
    
    @IBAction func connectionButton_Click(_ sender: Any) {
        if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: "ben"), user != nil {
            print("user exists")
            UserDefaults.standard.set(user.login, forKey: "connectedUser")
            let controller = TabBarController()
            self.present(controller, animated: true, completion: nil)
        } else {
            print("user not exists")
            if UsersDataHelpers.getFunc.setNewUser(login: "ben", password: "123", firstName: "", lastName: "", mail: "", image: nil) {
                print("user ctreated")
                let user = UsersDataHelpers.getFunc.searchUserByLogin(login: "ben")
                if user != nil {
                    UserDefaults.standard.set(user!.login, forKey: "connectedUser")
                    let controller = TabBarController()
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
    
}
