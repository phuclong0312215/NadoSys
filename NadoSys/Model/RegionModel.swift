//
//  RegionModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/17/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class RegionModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var id: Int = 0
    var parentId: Int = 0
    var area: String = ""
    var regionName: String = ""
    var isActive: Bool = true
    var orderby: Int = 0
    
    
    public func mapping(map: Map) {
        id    <- map["id"]
        area    <- map["area"]
        regionName    <- map["regionName"]
        parentId    <- map["parentId"]
        isActive    <- map["is_Active"]
        orderby    <- map["orderby"]
    }
    
}

