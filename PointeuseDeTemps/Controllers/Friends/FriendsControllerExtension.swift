//
//  FriendsControllerExtension.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 05/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

extension FriendsController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func initPickerView(){
        popPickerView.delegate = self
        popPickerView.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userForNewMessages.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if userForNewMessages[row].id > 0 {
            let userAPI: UserAPI = userForNewMessages[row]
            //return userAPI.login
            if userAPI.firstName != "" && userAPI.lastName != "" {
                return userAPI.firstName + " " + userAPI.lastName + " - " + userAPI.login + " (" + userAPI.mail + ")"
            } else if userAPI.firstName != "" && userAPI.lastName == "" {
                return userAPI.firstName + " - " + userAPI.login + " (" + userAPI.mail + ")"
            } else if userAPI.firstName == "" && userAPI.lastName != "" {
                return userAPI.lastName + " - " + userAPI.login + " (" + userAPI.mail + ")"
            } else {
                return userAPI.login + " (" + userAPI.mail + ")"
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if userForNewMessages[row].id > 0 {
            selectedPickerView = userForNewMessages[row]
        }
    }
    
}
