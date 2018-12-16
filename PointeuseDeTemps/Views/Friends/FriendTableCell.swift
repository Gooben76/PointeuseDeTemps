//
//  FriendTableViewCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 02/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class FriendTableCell: UITableViewCell {

    var friend: Friends!
    var userConnected : Users!
    
    @IBOutlet weak var loginLabel: LabelH2TS!
    @IBOutlet weak var activeLabel: LabelH4TS!
    
    func initCell(friend: Friends, userConnected: Users) {
        self.friend = friend
        self.userConnected = userConnected
        var info: String
    
        if friend.user.firstName != nil && friend.user.lastName != nil {
            info = friend.user.firstName! + " " + friend.user.lastName! + " (" + friend.user.login! + ")"
        } else if friend.user.firstName != nil && friend.user.lastName == nil {
            info = friend.user.firstName! + " (" + friend.user.login! + ")"
        } else if friend.user.firstName == nil && friend.user.lastName != nil {
            info = friend.user.lastName! + " (" + friend.user.login! + ")"
        } else {
            info = friend.user.login! + " (" + friend.user.mail! + ")"
        }
        loginLabel.text = info
        
        if friend.active {
            activeLabel.text = RSC_ACTIVE
        } else {
            activeLabel.text = RSC_INACTIVE
        }
    }
}
