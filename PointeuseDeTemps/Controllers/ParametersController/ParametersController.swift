//
//  ParametersController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 13/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ParametersController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var imageView: ImageViewTS!
    @IBOutlet weak var loginTF: TextFieldTS!
    @IBOutlet weak var passwordTF: TextFieldTS!
    @IBOutlet weak var mailTF: TextFieldTS!
    @IBOutlet weak var nameTF: TextFieldTS!
    @IBOutlet weak var firstNameTF: TextFieldTS!
    @IBOutlet weak var saveButton: ButtonTS!
    @IBOutlet weak var deconnectionButton: ButtonTS!
    @IBOutlet weak var deleteButton: ButtonTS!
    @IBOutlet weak var synchronizationLabel: LabelH2TitleTS!
    @IBOutlet weak var synchronizationSwitch: UISwitch!
    @IBOutlet weak var allowMessagesLabel: LabelH2TitleTS!
    @IBOutlet weak var allowMessagesSwitch: UISwitch!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topOfImageConstraint: NSLayoutConstraint!
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    var navigationBar: UINavigationBar?
    
    var imagePicker: UIImagePickerController?
    var userCreation: Bool = false
    var userConnected: Users?
    var selectImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardManagement()
        
        if let nav = navigationController {
            navigationBar = nav.navigationBar
            navigationBar!.items![0].title = RSC_USER
        }
        
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.allowsEditing = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pictureClick))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        loginTF.placeholder = RSC_LOGIN + "*"
        passwordTF.placeholder = RSC_PASSWORD + "*"
        mailTF.placeholder = RSC_EMAIL + "*"
        nameTF.placeholder = RSC_LASTNAME
        firstNameTF.placeholder = RSC_FIRSTNAME
        deconnectionButton.setTitle(RSC_DECONNECTION, for: .normal)
        deleteButton.setTitle(RSC_DELETE, for: .normal)
        synchronizationLabel.text = RSC_SYNCHRONIZATION
        allowMessagesLabel.text = RSC_ALLOW_MESSAGES
        
        loginTF.delegate = self
        passwordTF.delegate = self
        mailTF.delegate = self
        nameTF.delegate = self
        firstNameTF.delegate = self
        
        synchronizationSwitch.addTarget(self, action: #selector(self.synchronizationSwitchValueDidChange), for: .valueChanged)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        if view.frame.width != screenSize.width {
            widthConstraint.constant = screenSize.width - 20
            topOfImageConstraint.constant = 30
            scroll.contentSize = CGSize(width: widthConstraint.constant, height: 800)
        } else {
            widthConstraint.constant = view.frame.width - 20
            topOfImageConstraint.constant = 20
            scroll.contentSize = CGSize(width: widthConstraint.constant, height: 800)
        }
        scroll.isScrollEnabled = true
        
        if !selectImage {
            if !userCreation {
                loginTF.isEnabled = false
                mailTF.isEnabled = false
                saveButton.setTitle(RSC_SAVE, for: .normal)
                
                let usr = UserDefaults.standard.object(forKey: "connectedUser")
                if usr != nil, let login = usr as? String {
                    
                    if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login) {
                        userConnected = user
                        loginTF.text = userConnected!.login
                        passwordTF.text = userConnected!.password
                        mailTF.text = userConnected!.mail
                        nameTF.text = userConnected!.lastName
                        firstNameTF.text = userConnected!.firstName
                        synchronizationSwitch.isOn = userConnected!.synchronization
                        allowMessagesSwitch.isOn = userConnected!.allowMessages
                        if userConnected!.image != nil, let img = userConnected!.image as? UIImage {
                            imageView.image = img
                        }
                    } else {
                        UserDefaults.standard.removeObject(forKey: "connectedUser")
                        loginTF.text = ""
                        passwordTF.text = ""
                        mailTF.text = ""
                        nameTF.text = ""
                        firstNameTF.text = ""
                        synchronizationSwitch.isOn = false
                        allowMessagesSwitch.isOn = false
                        imageView.image = nil
                        userCreation = true
                    }
                }
                deconnectionButton.isHidden = false
                deleteButton.isHidden = false
            } else {
                loginTF.text = ""
                passwordTF.text = ""
                mailTF.text = ""
                nameTF.text = ""
                firstNameTF.text = ""
                imageView.image = nil
                synchronizationSwitch.isOn = false
                allowMessagesSwitch.isOn = false
                deconnectionButton.isHidden = true
                deleteButton.isHidden = true
                saveButton.setTitle(RSC_CREATION, for: .normal)
            }
        }
        
        if synchronizationSwitch.isOn{
            allowMessagesSwitch.isEnabled = true
            allowMessagesLabel.isEnabled = true
        } else {
            allowMessagesSwitch.isOn = false
            allowMessagesSwitch.isEnabled = false
            allowMessagesLabel.isEnabled = false
        }
    }

    @objc func pictureClick() {
        guard imagePicker != nil else {return}
        selectImage = true
        let alert = UIAlertController(title: RSC_SELECTPICTURE, message: RSC_SELECTMEDIA, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: RSC_CAMERA, style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker!.sourceType = .camera
                self.present(self.imagePicker!, animated: true, completion: nil)
            }
        }
        let library = UIAlertAction(title: RSC_PHOTOLIBRARY, style: .default) { (action) in
            self.imagePicker!.sourceType = .photoLibrary
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: RSC_CANCEL, style: .cancel, handler: nil)
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let pop = alert.popoverPresentationController {
                pop.sourceView = self.view
                pop.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
                pop.permittedArrowDirections = []
            }
        }
        self.present(alert, animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker!.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var picture: UIImage?
        if let changed = info[UIImagePickerControllerEditedImage] as? UIImage {
            picture = changed
        }
        if let selected = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picture = selected
        }
        imageView.image = picture
        imagePicker!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton_Click(_ sender: Any) {
        view.endEditing(true)
        if loginTF.text != nil, loginTF.text != "" {
            if mailTF.text != nil, mailTF.text != "" {
                if passwordTF.text != nil, passwordTF.text != "" {
                    if !userCreation {
                        if userConnected != nil {
                            userConnected!.password = passwordTF.text
                            userConnected!.mail = mailTF.text
                            userConnected!.firstName = firstNameTF.text
                            userConnected!.lastName = nameTF.text
                            userConnected!.image = imageView.image
                            userConnected!.synchronization = synchronizationSwitch.isOn
                            userConnected!.allowMessages = allowMessagesSwitch.isOn
                            if !UsersDataHelpers.getFunc.setUser(user: userConnected!) {
                                Alert.show.error(message: RSC_SAVE_ERROR, controller: self)
                            } else {
                                Alert.show.success(message: RSC_SAVE_OK, controller: self)
                            }
                        }
                    } else {
                        if UsersDataHelpers.getFunc.searchUserByLogin(login: loginTF.text!) != nil {
                            Alert.show.error(message: RSC_USER_LOGIN_EXIST_LOCALLY, controller: self)
                            return
                        }
                        if UsersDataHelpers.getFunc.searchUserByMail(mail: mailTF.text!) != nil {
                            Alert.show.error(message: RSC_USER_MAIL_EXIST_LOCALLY, controller: self)
                            return
                        }
                        
                        APIUsers.getFunc.getUserFromLoginOrMailExists(login: loginTF.text!, mail: mailTF.text!, token: "") { (response) in
                            if response == nil {
                                if UsersDataHelpers.getFunc.setNewUser(login: self.loginTF.text!, password: self.passwordTF.text!, firstName: self.firstNameTF.text, lastName: self.nameTF.text, mail: self.mailTF.text, image: self.imageView.image, synchronization: self.synchronizationSwitch.isOn, allowMessages: self.allowMessagesSwitch.isOn) {
                                    UserDefaults.standard.set(self.loginTF.text!, forKey: "connectedUser")
                                    UserDefaults.standard.set(self.passwordTF.text!, forKey: "connectedUserPassword")
                                    self.userCreation = false
                                    self.deleteButton.isEnabled = true
                                    self.deconnectionButton.isEnabled = true
                                    self.userConnected = UsersDataHelpers.getFunc.searchUserByLogin(login: self.loginTF.text!)
                                    let controller = TabBarController()
                                    self.present(controller, animated: true, completion: nil)
                                } else {
                                    Alert.show.error(message: RSC_ERR_USERCREATIONFAILED, controller: self)
                                }
                            } else {
                                Alert.show.error(message: RSC_USER_MAIL_EXIST_ONSERVER, controller: self)
                                return
                            }
                        }
                    }
                } else {
                    Alert.show.error(message: RSC_PASSWORD_REQUIRED, controller: self)
                }
            } else {
                Alert.show.error(message: RSC_MAIL_REQUIRED, controller: self)
            }
        } else {
            Alert.show.error(message: RSC_LOGIN_REQUIRED, controller: self)
        }
    }
    
    @IBAction func deconnectionButton_Click(_ sender: Any) {
        view.endEditing(true)
        UserDefaults.standard.removeObject(forKey: "connectedUser")
        UserDefaults.standard.removeObject(forKey: "connectedUserPassword")
        let controller = ConnectionController()
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func deleteButton_Click(_ sender: Any) {
        view.endEditing(true)
        if userConnected != nil {
            if UsersDataHelpers.getFunc.delUser(user: userConnected!) {
                UserDefaults.standard.removeObject(forKey: "connectedUser")
                UserDefaults.standard.removeObject(forKey: "connectedUserPassword")
                let controller = ConnectionController()
                self.present(controller, animated: true, completion: nil)
            } else {
                Alert.show.error(message: RSC_DELETE_ERROR, controller: self)
            }
        }
    }
    
    @objc func synchronizationSwitchValueDidChange(sender: UISwitch!) {
        if sender.isOn{
            allowMessagesSwitch.isEnabled = true
            allowMessagesLabel.isEnabled = true
        } else {
            allowMessagesSwitch.isOn = false
            allowMessagesSwitch.isEnabled = false
            allowMessagesLabel.isEnabled = false
        }
    }
    
}
