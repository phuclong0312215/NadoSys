//
//  ProvinceModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/17/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class ProvinceModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var provinceId: Int = 0
    var regionId: Int = 0
    var provinceName: String = ""
    var provinceName_Vi_vn: String = ""
    var regionName: String = ""
    
    public func mapping(map: Map) {
        provinceId    <- map["provinceId"]
        regionId    <- map["regionId"]
        regionName    <- map["regionName"]
        provinceName    <- map["provinceName"]
        provinceName_Vi_vn    <- map["provinceName_Vi_vn"]
    }
    
}
