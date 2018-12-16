//
//  Friends.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 14/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import Foundation

class Friends {
    
    private var _user: Users
    private var _active: Bool
    
    var user: Users {
        get {
            return self._user
        }
        set {
            _user = user
        }
    }
    
    var active: Bool {
        get {
            return self._active
        }
        set {
            _active = active
        }
    }
    
    init(user: Users, active: Bool) {
        self._user = user
        self._active = active
    }
}
