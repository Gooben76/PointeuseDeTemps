//
//  DoubleExtension.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 10/11/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

extension Double {
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
}
