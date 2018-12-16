//
//  LabelChat.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 08/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class TextViewChat: UITextView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initObj()
    }
    
    func initObj() {
        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.backgroundColor = UIColor.init(red: 210, green: 210, blue: 210, alpha: 1).cgColor
        textColor = UIColor.darkGray
        font = UIFont.systemFont(ofSize: 15)
    }

}
