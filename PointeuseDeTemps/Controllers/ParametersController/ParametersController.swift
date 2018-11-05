//
//  ParametersController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 13/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ParametersController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    var navigationBar: UINavigationBar?
    
    var imagePicker: UIImagePickerController?
    var userCreation: Bool = false
    var userConnected: Users?
    var selectImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        loginTF.placeholder = RSC_LOGIN
        passwordTF.placeholder = RSC_PASSWORD
        mailTF.placeholder = RSC_EMAIL
        nameTF.placeholder = RSC_LASTNAME
        firstNameTF.placeholder = RSC_FIRSTNAME
        saveButton.setTitle(RSC_SAVE, for: .normal)
        deconnectionButton.setTitle(RSC_DECONNECTION, for: .normal)
        deleteButton.setTitle(RSC_DELETE, for: .normal)
        synchronizationLabel.text = RSC_SYNCHRONIZATION
        allowMessagesLabel.text = RSC_ALLOW_MESSAGES
        
        scroll.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        widthConstraint.constant = view.frame.width - 20
        scroll.contentSize = CGSize(width: widthConstraint.constant, height: view.frame.height)
        
        if !selectImage {
            if !userCreation {
                let usr = UserDefaults.standard.object(forKey: "connectedUser")
                if usr != nil, let login = usr as? String {
                    if let user = UsersDataHelpers.getFunc.searchUserByLogin(login: login), user != nil {
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
                        deleteButton.isEnabled = false
                        deconnectionButton.isEnabled = false
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
            } else {
                loginTF.text = ""
                passwordTF.text = ""
                mailTF.text = ""
                nameTF.text = ""
                firstNameTF.text = ""
                imageView.image = nil
                synchronizationSwitch.isOn = false
                allowMessagesSwitch.isOn = false
            }
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
        var saveOk: Bool = false
        if synchronizationSwitch.isOn && mailTF.text == "" {
            Alert.show.error(message: RSC_MAIL_REQUIRED, controller: self)
            return
        }
        if loginTF.text != nil, loginTF.text != "" {
            if passwordTF.text != nil, passwordTF.text != "" {
                let mail: String = ""
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
                            saveOk = true
                            Alert.show.success(message: RSC_SAVE_OK, controller: self)
                        }
                    }
                } else {
                    if UsersDataHelpers.getFunc.setNewUser(login: loginTF.text!, password: passwordTF.text!, firstName: firstNameTF.text, lastName: nameTF.text, mail: mail, image: imageView.image) {
                        UserDefaults.standard.set(loginTF.text!, forKey: "connectedUser")
                        saveOk = true
                        userCreation = false
                        deleteButton.isEnabled = true
                        deconnectionButton.isEnabled = true
                        userConnected = UsersDataHelpers.getFunc.searchUserByLogin(login: loginTF.text!)
                        let controller = TabBarController()
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        Alert.show.error(message: RSC_ERR_USERCREATIONFAILED, controller: self)
                    }
                }
            } else {
                Alert.show.error(message: RSC_PASSWORD_REQUIRED, controller: self)
            }
        } else {
            Alert.show.error(message: RSC_LOGIN_REQUIRED, controller: self)
        }
        if saveOk && userConnected != nil {
            if userConnected!.synchronization {
                if userConnected!.id == 0 {
                    APIUsers.getFunc.createUserToAPI(userId: userConnected!, token: "") { (userAPI) in
                        if userAPI != nil {
                            self.userConnected!.id = Int32(userAPI!.id)
                            if UsersDataHelpers.getFunc.setUser(user: self.userConnected!) {
                                Alert.show.success(message: "Synchro ok, id = \(userAPI!.id)", controller: self)
                            }
                        } else {
                            Alert.show.error(message: RSC_SYNCHRONIZATION_ERROR, controller: self)
                        }
                    }
                } else {
                    APIUsers.getFunc.updateUserToAPI(userId: userConnected!, token: "") { (status) in
                        print("Statut : \(status)")
                    }
                }
            }
        }
    }
    
    @IBAction func deconnectionButton_Click(_ sender: Any) {
        view.endEditing(true)
        UserDefaults.standard.removeObject(forKey: "connectedUser")
        let controller = ConnectionController()
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func deleteButton_Click(_ sender: Any) {
        view.endEditing(true)
        if userConnected != nil {
            if UsersDataHelpers.getFunc.delUser(user: userConnected!) {
                UserDefaults.standard.removeObject(forKey: "connectedUser")
                let controller = ConnectionController()
                self.present(controller, animated: true, completion: nil)
            } else {
                Alert.show.error(message: RSC_DELETE_ERROR, controller: self)
            }
        }
    }
    
}
