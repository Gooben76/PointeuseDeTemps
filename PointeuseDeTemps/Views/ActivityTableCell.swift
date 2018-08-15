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
    
    func initCell(activity: Activities) {
        self.activity = activity
        activityTextField.delegate = self
        orderTextField.delegate = self
        positionSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        
        activityTextField.placeholder = RSC_ACTIVITYNAME
        orderTextField.placeholder = RSC_ACTIVITY_ORDER
        gpsPositionLabel.text = RSC_GPSPOSITION
        
        activityTextField.text = activity.activityName
        positionSwitch.isOn = activity.gpsPosition
        if activity.image != nil, let image = activity.image as? UIImage {
            imageActivity.image = image
        } else {
            imageActivity.image = #imageLiteral(resourceName: "camera-50")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == activityTextField {
            if let text = textField.text {
                print("Activité : " + text)
            }
        } else {
            if let text = textField.text {
                print("Ordre : " + text)
            }
        }
    }
    
    @objc func switchValueDidChange(sender: UISwitch!) {
        if sender.isOn {
            print("GPS position : Oui")
        } else {
            print("GPS position : Non")
        }
    }
    
}
