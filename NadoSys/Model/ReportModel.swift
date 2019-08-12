//
//  ReportModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/9/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class EmployeeAvgModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var amount: Int = 0
    var objectName: String = ""
    var ihsAmount: String = ""
    var displayShare: Int = 0
    var displayWM: Int = 0
    var displayREF: Int = 0
    var displayAC: Int = 0
    var sellYearAchieved: Int = 0
    public func mapping(map: Map) {
        amount    <- map["amount"]
        objectName    <- map["objectName"]
        ihsAmount    <- map["ihsAmount"]
        displayShare    <- map["displayShare"]
        displayWM    <- map["displayWM"]
        displayREF    <- map["displayREF"]
        displayAC    <- map["displayAC"]
        sellYearAchieved    <- map["sellYearAchieved"]
    }
    
}
public class EmployeeAttModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var employeeId: Int = 0
    var employeeCode: String = ""
    var employeeName: String = ""
    var mobile: String = ""
    var avatar: String = ""
    var position: String = ""
    var mon: String = ""
    var tue: String = ""
    var wed: String = ""
    var thu: String = ""
    var fri: String = ""
    var sat: String = ""
    var sun: String = ""
    public func mapping(map: Map) {
        employeeId    <- map["employeeId"]
        employeeCode    <- map["employeeCode"]
        employeeName    <- map["employeeName"]
        mobile    <- map["mobile"]
        avatar    <- map["avatar"]
        position    <- map["position"]
        mon    <- map["mon"]
        tue    <- map["tue"]
        wed    <- map["wed"]
        thu    <- map["thu"]
        fri    <- map["fri"]
        sat    <- map["sat"]
        sun    <- map["sun"]
    }
    
}

