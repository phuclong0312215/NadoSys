//
//  RegionSelectModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/18/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class RegionSelectModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var id: Int = 0
    var name: String = ""
    var type: String = ""
    var name_vn: String = ""
    
    public func mapping(map: Map) {
        id    <- map["id"]
        name    <- map["name"]
        type    <- map["type"]
        name_vn    <- map["name_vn"]
    }
    
}

