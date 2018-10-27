//
//  Character.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 27/10/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

extension Character {
    
    var ascii: UInt32? {
        return self.unicodeScalars[self.unicodeScalars.startIndex].value
    }
}
