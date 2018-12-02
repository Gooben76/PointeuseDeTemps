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
    
    func initCell(friend: Friends, userConnected: Users) {
        self.friend = friend
        self.userConnected = userConnected
    }
}
