//
//  ConnectionController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 1/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ConnectionController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var connexionButton: ButtonTS!
    @IBOutlet weak var userCreationButton: ButtonTS!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = RSC_IDENTIFICATION
        loginTF.placeholder = RSC_LOGIN
        passwordTF.placeholder = RSC_PASSWORD
        connexionButton.setTitle(RSC_CONNECTION, for: .normal)
        userCreationButton.setTitle(RSC_USERCREATION, for: .normal)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let usr = UserDefaults.standard.object(forKey: "connectedUser")
        if usr != nil, let login = usr as? String {
            if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login), user != nil {
                let controller = TabBarController()
                self.present(controller, animated: true, completion: nil)
            } else {
                UserDefaults.standard.removeObject(forKey: "connectedUser")
            }
        }
    }
    
    @IBAction func connectionButton_Click(_ sender: Any) {
        view.endEditing(true)
        if loginTF.text != "", let login = loginTF.text {
            if passwordTF.text != "", let password = passwordTF.text {
                if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login), user != nil {
                    if password == user.password {
                        UserDefaults.standard.set(user.login, forKey: "connectedUser")
                        let controller = TabBarController()
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        Alert.show.error(message: RSC_WRONG_PASSWORD, controller: self)
                    }
                } else {
                    Alert.show.error(message: RSC_USER_UNKNOWED, controller: self)
                }
            } else {
                Alert.show.error(message: RSC_PASSWORD_REQUIRED, controller: self)
            }
        } else {
            Alert.show.error(message: RSC_LOGIN_REQUIRED, controller: self)
        }
    }
    
    @IBAction func userCreationButton_Click(_ sender: Any) {
        view.endEditing(true)
        let controller = ParametersController()
        controller.userCreation = true
        self.present(controller, animated: true, completion: nil)
    }
}
