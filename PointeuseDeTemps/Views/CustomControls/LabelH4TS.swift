//
//  LabelH4TS.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 16/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class LabelH4TS: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initObj()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initObj()
    }
    
    func initObj() {
        textColor = UIColor.darkGray
        font = UIFont.systemFont(ofSize: 12)
    }

}
