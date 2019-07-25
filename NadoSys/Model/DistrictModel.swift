//
//  DistrictModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/17/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class DistrictModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var provinceId: Int = 0
    var districtId: Int = 0
    var districtName: String = ""
    var districtName_Vi_vn: String = ""
    
    public func mapping(map: Map) {
        districtId    <- map["districtId"]
        provinceId    <- map["provinceId"]
        districtName    <- map["distrctName"]
        districtName_Vi_vn    <- map["distrctName_Vi_vn"]
    }
    
}
