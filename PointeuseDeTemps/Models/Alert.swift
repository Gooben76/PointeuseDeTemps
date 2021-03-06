//
//  Alert.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 1/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class Alert {
    
    static let show = Alert()
    
    func error(message: String, controller: UIViewController) {
        let elm = UIAlertController(title: RSC_ERROR, message: message, preferredStyle: .alert)
        elm.addAction(UIAlertAction(title: RSC_OK, style: .default, handler: nil))
        controller.present(elm, animated: true, completion: nil)
    }
    
    func complete(message: String, controller: UIViewController) {
        let elm = UIAlertController(title: RSC_INFORMATION, message: message, preferredStyle: .alert)
        elm.addAction(UIAlertAction(title: RSC_OK, style: .default, handler: nil))
        controller.present(controller, animated: true) {
            let connect = ConnectionController()
            controller.present(connect, animated: true, completion: nil)
        }
    }
    
    func success(message: String, controller: UIViewController) {
        let elm = UIAlertController(title: RSC_INFORMATION, message: message, preferredStyle: .alert)
        elm.addAction(UIAlertAction(title: RSC_OK, style: .default, handler: nil))
        controller.present(elm, animated: true, completion: nil)
    }
}
