//
//  ConnectionController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 1/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ConnectionController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: LabelH1TS!
    @IBOutlet weak var loginTF: TextFieldTS!
    @IBOutlet weak var passwordTF: TextFieldTS!
    @IBOutlet weak var connexionButton: ButtonTS!
    @IBOutlet weak var userCreationButton: ButtonSmallTS!
    @IBOutlet weak var mailTF: TextFieldTS!
    @IBOutlet weak var connectFromServerButton: ButtonSmallTS!
    @IBOutlet weak var creationUserFromServerButton: ButtonTS!
    
    var countTimer: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardManagement()
        
        titleLabel.text = RSC_IDENTIFICATION
        loginTF.placeholder = RSC_LOGIN
        passwordTF.placeholder = RSC_PASSWORD
        mailTF.placeholder = RSC_EMAIL
        connexionButton.setTitle(RSC_CONNECTION, for: .normal)
        userCreationButton.setTitle(RSC_USERCREATION, for: .normal)
        creationUserFromServerButton.setTitle(RSC_CREATIONFROMSERVER, for: .normal)
        
        connectFromServerButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        connectFromServerButton.titleLabel!.textAlignment = .center
        connectFromServerButton.setTitle(RSC_CREATEUSERFROMSERVER, for: .normal)
        
        mailTF.isHidden = true
        creationUserFromServerButton.isHidden = true
        
        loginTF.delegate = self
        passwordTF.delegate = self
        mailTF.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let usr = UserDefaults.standard.object(forKey: "connectedUser")
        let usrPwd = UserDefaults.standard.object(forKey: "connectedUserPassword")
        if usr != nil, let login = usr as? String {
            if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login) {
                Synchronization.getFunc.userSynchronization(userConnected: user) { (passwordAfterSynchronization) in
                    if usrPwd != nil, let loginPwd = usrPwd as? String {
                        if loginPwd == passwordAfterSynchronization {
                            Synchronization.getFunc.generalSynchronization(userConnected: user)
                            let controller = TabBarController()
                            self.present(controller, animated: true, completion: nil)
                        }
                    } else {
                        UserDefaults.standard.removeObject(forKey: "connectedUserPassword")
                        self.loginTF.text = login
                    }
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "connectedUser")
                UserDefaults.standard.removeObject(forKey: "connectedUserPassword")
            }
        }
    }
    
    @IBAction func connectionButton_Click(_ sender: Any) {
        view.endEditing(true)
        UserDefaults.standard.removeObject(forKey: "connectedUser")
        UserDefaults.standard.removeObject(forKey: "connectedUserPassword")
        if loginTF.text != "", let login = loginTF.text {
            let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login)
            if user != nil {
                Synchronization.getFunc.userSynchronization(userConnected: user) { (passwordAfterSynchronization) in
                    if self.passwordTF.text != "", let password = self.passwordTF.text {
                        if password == passwordAfterSynchronization {
                            UserDefaults.standard.set(user!.login, forKey: "connectedUser")
                            UserDefaults.standard.set(passwordAfterSynchronization, forKey: "connectedUserPassword")
                            Synchronization.getFunc.generalSynchronization(userConnected: user)
                            let controller = TabBarController()
                            self.present(controller, animated: true, completion: nil)
                        } else {
                            Alert.show.error(message: RSC_WRONG_PASSWORD, controller: self)
                        }
                    } else {
                        Alert.show.error(message: RSC_PASSWORD_REQUIRED, controller: self)
                    }
                }
            } else {
                Alert.show.error(message: RSC_USER_UNKNOWED, controller: self)
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
    
    @IBAction func connectFromServerButton_click(_ sender: Any) {
        if mailTF.isHidden {
            mailTF.isHidden = false
            passwordTF.isHidden = true
            creationUserFromServerButton.isHidden = false
            connexionButton.isHidden = true
            userCreationButton.isHidden = true
        } else {
            mailTF.isHidden = true
            passwordTF.isHidden = false
            creationUserFromServerButton.isHidden = true
            connexionButton.isHidden = false
            userCreationButton.isHidden = false
        }
    }
    
    @IBAction func creationUserFromServerButton_click(_ sender: Any) {
        view.endEditing(true)
        if loginTF.text != "", let login = loginTF.text {
            if UsersDataHelpers.getFunc.searchUserByLogin(login: login) != nil {
                Alert.show.error(message: RSC_USER_LOGIN_EXIST_LOCALLY, controller: self)
                return
            }
            UserDefaults.standard.removeObject(forKey: "connectedUser")
            UserDefaults.standard.removeObject(forKey: "connectedUserPassword")
        
            if mailTF.text != "", let mail = mailTF.text {
                if UsersDataHelpers.getFunc.searchUserByMail(mail: mail) != nil {
                    Alert.show.error(message: RSC_USER_MAIL_EXIST_LOCALLY, controller: self)
                    return
                }
                APIUsers.getFunc.getUserFromLoginAndMail(login: login, mail: mail, token: "") { (data) in
                    if data != nil {
                        if UsersDataHelpers.getFunc.setNewUserFromUserAPI(userAPI: data!) {
                            
                            Alert.show.success(message: RSC_USERCREATIONFROMSERVERSUCCEED, controller: self)
                        } else {
                            Alert.show.error(message: RSC_USERCREATIONFAILED, controller: self)
                        }
                    } else {
                        Alert.show.error(message: RSC_NOUSERONSERVER, controller: self)
                    }
                }
                self.mailTF.isHidden = true
                passwordTF.isHidden = false
                creationUserFromServerButton.isHidden = true
                connexionButton.isHidden = false
                userCreationButton.isHidden = false
            } else {
                Alert.show.error(message: RSC_MAIL_REQUIRED, controller: self)
            }
        } else {
            Alert.show.error(message: RSC_LOGIN_REQUIRED, controller: self)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldToEdit = textField
    }
}
