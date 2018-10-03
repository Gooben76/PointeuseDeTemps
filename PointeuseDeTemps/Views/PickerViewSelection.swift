//
//  PickerViewSelection.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 23/09/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class PickerViewSelection : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        layer.cornerRadius = 10
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.75
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowColor = UIColor.black.cgColor
    }
}
