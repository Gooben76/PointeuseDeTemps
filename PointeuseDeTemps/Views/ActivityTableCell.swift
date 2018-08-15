//
//  ActivityCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 14/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ActivityTableCell: UITableViewCell {

    @IBOutlet weak var imageActivity: ImageViewTS!
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var positionSwitch: UISwitch!
    @IBOutlet weak var orderTextField: UITextField!
    
    var activity : Activities!
    
    func initCell(activity: Activities) {
        self.activity = activity
        
        activityTextField.text = activity.activityName
        positionSwitch.isOn = activity.gpsPosition
        if activity.image != nil, let image = activity.image as? UIImage {
            imageActivity.image = image
        } else {
            imageActivity.image = #imageLiteral(resourceName: "camera-50")
        }
    }
}
