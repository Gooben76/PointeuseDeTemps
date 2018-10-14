//
//  ActivityCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 14/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ActivityTableCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var imageActivity: ImageViewTS!
    @IBOutlet weak var activityTextField: TextFieldTS!
    @IBOutlet weak var positionSwitch: UISwitch!
    @IBOutlet weak var orderTextField: TextFieldSmallTS!
    @IBOutlet weak var gpsPositionLabel: LabelH2TS!
    @IBOutlet weak var orderLabel: LabelH2TS!
    
    var activity : Activities!
    var userConnected: Users!
    
    func initCell(activity: Activities, userConnected: Users) {
        self.activity = activity
        self.userConnected = userConnected
        activityTextField.delegate = self
        orderTextField.delegate = self
        positionSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        
        activityTextField.placeholder = RSC_ACTIVITYNAME
        orderTextField.placeholder = RSC_ACTIVITY_ORDER
        gpsPositionLabel.text = RSC_GPSPOSITION
        orderLabel.text = RSC_ORDER
        
        activityTextField.text = activity.activityName
        positionSwitch.isOn = activity.gpsPosition
        orderTextField.text = String(activity.order)
        if activity.image != nil, let image = activity.image as? UIImage {
            imageActivity.image = image
        } else {
            imageActivity.image = #imageLiteral(resourceName: "camera-50")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Event")
        var toSave: Bool = false
        if textField == activityTextField {
            print("activité")
            if let text = textField.text {
                if text != activity.activityName {
                    print("Nom a changé")
                    if ActivitiesDataHelpers.getFunc.existActivityName(activityName: text, userConnected: userConnected) {
                        print("Nom existe")
                        activityTextField.text = activity.activityName
                        NotificationCenter.default.post(name: .showErrorMessageInActivitiesController, object: self, userInfo: ["message": RSC_ERROR_ACTIVITYNAMEEXISTS])
                    } else {
                        print("Nom n'existe pas")
                        activity.activityName = text
                        toSave = true
                    }
                }
            }
        } else if textField == orderTextField {
            print("Ordre")
            if let text = textField.text, let order = Int32(text) {
                if order != activity.order {
                    print("Ordre a changé")
                    if ActivitiesDataHelpers.getFunc.existActivityOrder(order: order, userConnected: userConnected) {
                        print("Ordre existe")
                        orderTextField.text = String(activity.order)
                        NotificationCenter.default.post(name: .showErrorMessageInActivitiesController, object: self, userInfo: ["message": RSC_ERROR_ORDEREXISTS])
                    } else {
                        print("Ordre n'existe pas")
                        activity.order = order
                        toSave = true
                    }
                }
            }
        }
        if toSave {
            if !ActivitiesDataHelpers.getFunc.setActivity(activity: activity, userConnected: userConnected) {
                print("Erreur de sauvegarde de l'activité")
            }
            NotificationCenter.default.post(name: .refreshActivitiesController, object: self)
            toSave = false
        }
    }
    
    @objc func switchValueDidChange(sender: UISwitch!) {
        if sender.isOn {
            activity.gpsPosition = true
        } else {
            activity.gpsPosition = false
        }
        if !ActivitiesDataHelpers.getFunc.setActivity(activity: activity, userConnected: userConnected) {
            print("Erreur de sauvegarde de l'activité")
        }
    }
    
}
