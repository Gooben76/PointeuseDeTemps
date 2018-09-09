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
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var positionSwitch: UISwitch!
    @IBOutlet weak var orderTextField: UITextField!
    @IBOutlet weak var gpsPositionLabel: UILabel!
    
    var activity : Activities!
    var userConnected: Users?
    
    func initCell(activity: Activities, userConnected: Users) {
        self.activity = activity
        self.userConnected = userConnected
        activityTextField.delegate = self
        orderTextField.delegate = self
        positionSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        
        activityTextField.placeholder = RSC_ACTIVITYNAME
        orderTextField.placeholder = RSC_ACTIVITY_ORDER
        gpsPositionLabel.text = RSC_GPSPOSITION
        
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
        if textField == activityTextField {
            if let text = textField.text {
                activity.activityName = text
            }
        } else {
            if let text = textField.text, let order = Int32(text) {
                activity.order = order
            }
        }
        if !ActivitiesDataHelpers.getFunc.setActivity(activity: activity, userConnected: userConnected) {
            print("Erreur de sauvegarde de l'activité")
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
