//
//  ButtonSmallTS.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 24/11/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ButtonSmallTS: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initObj()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initObj()
    }
    
    func initObj() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        tintColor = UIColor.lightGray
        
        tintAdjustmentMode = .automatic
        setTitleColor(UIColor.lightGray, for: .normal)
    }
}
