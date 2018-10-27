//
//  LabelH3TitleTS.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 6/10/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class LabelH3TitleTS: UILabel {

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
        font = UIFont.boldSystemFont(ofSize: 15)
    }

}
