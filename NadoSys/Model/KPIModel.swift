//
//  KPIModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/8/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class KPIModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    
    var requieCheckIn: Int = 0
    var isSaleIn: Int = 0
    var isDisplayImage: Int = 0
    var isDisplay: Int = 0
    var isSaleThrough: Int = 0
    var isSaleOut: Int = 0
    var isCheckOut: Int = 0
    var isCheckIn: Int = 0
    var orderby: Int = 0
    var active: Int = 0
    var functionIcon: String = ""
    var functionName_vi_vn: String = ""
    var functionName: String = ""
    var id: Int = 0
    public func mapping(map: Map) {
        requieCheckIn      <- map["requieCheckIn"]
        isSaleIn    <- map["isSaleIn"]
        isDisplayImage  <- map["isDisplayImage"]
        isDisplay  <- map["isDisplay"]
        isSaleThrough      <- map["isSaleThrough"]
        isSaleOut      <- map["isSaleOut"]
        isCheckOut    <- map["isCheckOut"]
        isCheckIn  <- map["isCheckIn"]
        orderby  <- map["orderby"]
        active      <- map["active"]
        functionIcon  <- map["functionIcon"]
        functionName_vi_vn  <- map["functionName_vi_vn"]
        functionName      <- map["functionName"]
        id      <- map["id"]
    }
    
}




