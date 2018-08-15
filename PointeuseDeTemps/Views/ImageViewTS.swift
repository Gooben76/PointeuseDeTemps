//
//  ImageTS.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 15/08/18.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class ImageViewTS : UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initObj()
    }
    
    func initObj() {
        self.layer.cornerRadius = 20
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
}
