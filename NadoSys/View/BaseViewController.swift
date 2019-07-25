//
//  BaseViewController.swift
//  BEKOSALES
//
//  Created by Nguyen Tien on 7/2/18.
//  Copyright © 2018 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    fileprivate var _ACCESS_TOKEN: String = ""
    fileprivate var _EMPLOYEENAME: String = ""
    fileprivate var _POSITION: String = ""
    fileprivate var _EMPLOYEECODE: String = ""
   
    var EMPLOYEECODE: String{
        get{
            return self._EMPLOYEECODE
        }
    }
    var ACCESS_TOKEN: String{
        get{
            return self._ACCESS_TOKEN
        }
    }
    var EMPLOYEENAME : String{
        get{
            return self._EMPLOYEENAME
        }
    }
    var POSITION : String{
        get{
            return self._POSITION
        }
    }

    override func viewDidLoad() {
        if let value = Preferences.object(key: "EMPLOYEECODE") as? String{
            _EMPLOYEECODE = value
        }
        if let value = Preferences.object(key: "EMPLOYEENAME") as? String{
            _EMPLOYEENAME = value
        }
        if let value = Preferences.object(key: "POSITION") as? String{
            _POSITION = value
        }
        if let value = Preferences.object(key: "ACCESS_TOKEN") as? String{
            _ACCESS_TOKEN = value
        }
    }
    
   
   
}
