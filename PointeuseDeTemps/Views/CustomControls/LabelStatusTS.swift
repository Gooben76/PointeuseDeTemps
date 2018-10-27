//
//  LabelStatusTS.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 7/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class LabelStatusTS: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initObj()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initObj()
    }
    
    func initObj() {
        textColor = UIColor.green
        font = UIFont.boldSystemFont(ofSize: 23)
    }

}
