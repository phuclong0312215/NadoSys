//
//  ILogin.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/8/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
protocol ILogin {
    func GetById(_ id: Int,completionHandler: @escaping(LoginModel?,String?) -> ())
    func SaveInfo(_ data: Data,url: String, completionHandler: @escaping (AnyObject?, String?) -> ())
    func Login(_ data: Data,url: String, completionHandler: @escaping (LoginModel?, String?) -> ())
}

