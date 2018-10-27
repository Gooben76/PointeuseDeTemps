//
//  EncodeHelpers.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 27/10/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class EncodeHelpers {
    
    static let getFunc = EncodeHelpers()
    
    func crypte(key: String!) -> String {
        var outData: String = ""
        for character in key {
            let asc = character.ascii!
            if asc < 100 {
                outData += "0\(asc)"
            } else {
                outData += "\(asc)"
            }
        }
        return outData
    }
    
    func decrypte(key: String!) -> String {
        var outData: String = ""
        var i = 0
        while i < key.count {
            let value = key[key.index(key.startIndex, offsetBy: i)..<key.index(key.startIndex, offsetBy: i+3)]
            let intValue = Int(value)
            let c = Character(UnicodeScalar(intValue!)!)
            outData += String(c)
            i += 3
        }
        return outData
    }
}
