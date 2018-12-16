//
//  UIViewControllerExtension.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 09/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func keyboardManagement() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    func keyboardManagementInTableView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func keyboardShow(notification: Notification) {
        if let rectKeyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, view.frame.minY == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.frame.origin.y -= rectKeyboard.height
                })
        }
    }
    
    @objc func keyboardDisappear() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
