//
//  UIViewExtension.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 27/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let parentResponder2 = parentResponder as? UIViewController {
                return parentResponder2
            }
        }
        return nil
    }
}
