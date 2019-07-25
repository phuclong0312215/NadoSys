//
//  LoginModel.swift
//  Recruiment
//
//  Created by Nguyen Phuc Long on 3/18/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class LoginModel: NSObject, Mappable,Codable{
    var employeeId: Int = 0
    var employeeName: String = ""
    var mobile: String = ""
    var userName: String = ""
    var employeeCode: String = ""
    var access_token: String = ""
    var locationCode: String = ""
    var position: String = ""
    var parentId: Int = 0
    var password: String = ""
    
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
   public func mapping(map: Map) {
        employeeId            <- map["employeeId"]
        employeeName            <- map["employeeName"]
        mobile    <- map["mobile"]
        userName    <- map["userName"]
        employeeCode    <- map["employeeCode"]
        access_token    <- map["access_token"]
        locationCode    <- map["locationCode"]
        position    <- map["position"]
        parentId    <- map["parentId"]
        password    <- map["password"]
    }
}
