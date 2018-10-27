//
//  LabelH1TS.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 5/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class LabelH1TS: UILabel {

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
        textColor = UIColor.darkGray
        font = UIFont.systemFont(ofSize: 20)
    }

}
