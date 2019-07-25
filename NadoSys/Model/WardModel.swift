//
//  WardModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/17/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class WardModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var provinceId: Int = 0
    var districtId: Int = 0
    var wardId: Int = 0
    var wardName: String = ""
    var wardName_Vi_vn: String = ""
    
    public func mapping(map: Map) {
        wardId    <- map["wardId"]
        provinceId    <- map["provinceId"]
        districtId    <- map["districtId"]
        wardName    <- map["wardName"]
        wardName_Vi_vn    <- map["wardName_Vi_vn"]
    }
    
}
