//
//  MessagesControllerExtension.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 09/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

extension MessagesController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = messageTextView.text {
            changeTextViewSize(text: text)
        } else {
            changeTextViewSize(text: "")
        }
    }
    
    func changeTextViewSize(text: String) {
        let hauteur = text.hauteur(largeur: messageTextView.frame.width, font: UIFont.systemFont(ofSize: 17))
        if hauteur + 20 > 50 {
            UIView.animate(withDuration: 0.35, animations: {
                self.messageViewHeightConstraint.constant = hauteur + 20
                self.messageTextViewHeightConstraint.constant = hauteur
            })
        } else {
            UIView.animate(withDuration: 0.35, animations: {
                self.messageViewHeightConstraint.constant = 50
                self.messageTextViewHeightConstraint.constant = hauteur
            })
        }
    }
}
