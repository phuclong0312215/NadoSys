//
//  Preferences.swift
//  Nestle
//
//  Created by PHUCLONG on 8/9/17.
//  Copyright © 2017 PHUCLONG. All rights reserved.
//

import Foundation
import UIKit
class Preferences {
    static var PARAMATER = UserDefaults()
    init() {
       
    }
    static func put(key: String,value: String) {
        
        PARAMATER.setValue(value, forKeyPath: key)

    }
    static func get(key: String) -> String {
        if let value = (PARAMATER.object(forKey: key) as? String){
            return value
        }
        return "0"
    }
    static func object(key: String) -> Any? {
        return PARAMATER.object(forKey: key)
    }

}
