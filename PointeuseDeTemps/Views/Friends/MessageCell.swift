//
//  MessageCell.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 10/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {

    @IBOutlet weak var bubble: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet var bubbleWidthConstraint: NSLayoutConstraint!
    @IBOutlet var leftBubbleConstraint: NSLayoutConstraint!
    @IBOutlet var rightBubbleConstraint: NSLayoutConstraint!
    
    var message: Messages!
    var userConnected: Users!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func initCell(message: Messages, userConnected: Users) {
        self.message = message
        self.userConnected = userConnected
        
        bubbleWidthConstraint.constant = 200
        leftBubbleConstraint.isActive = true
        rightBubbleConstraint.isActive = true
        bubble.layer.cornerRadius = 10
        
        if message.userFromId == userConnected {
            leftBubbleConstraint.isActive = false
            bubble.backgroundColor = blueBubble
        } else {
            rightBubbleConstraint.isActive = false
            bubble.backgroundColor = greenBubble
        }
        
        if let text = self.message.message {
            textLabel.text = text
            let textWidth = text.largeur(largeur: UIScreen.main.bounds.width - 100, font: UIFont.systemFont(ofSize: 17)) + 32
            if textWidth < 75 {
                bubbleWidthConstraint.constant = 75
            } else {
                bubbleWidthConstraint.constant = textWidth
            }
        }
        
        if message.modifiedDate != nil {
            dateLabel.text = message.modifiedDate!.timeIntervalSince1970.getVisibleDateForMessage()
        }
    }
}
