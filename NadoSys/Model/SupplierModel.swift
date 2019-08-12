//
//  SupplierModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/11/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class SupplierModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var provinceId: Int = 0
    var districtId: Int = 0
    var wardId: Int = 0
    var regionId: Int = 0
    var supplierId: Int = 0
    var supplierCode: String = ""
    var supplierName: String = ""
    var address: String = ""
    var area: String = ""
    var createdDate: String = ""
    var isCheck: Int = 0
    public func mapping(map: Map) {
        wardId    <- map["wardId"]
        provinceId    <- map["provinceId"]
        districtId    <- map["districtId"]
        regionId    <- map["regionId"]
        supplierId    <- map["supplierId"]
        supplierCode    <- map["supplierCode"]
        supplierName    <- map["supplierName"]
        address    <- map["address"]
        area    <- map["area"]
        createdDate    <- map["createdDate"]
    }
    
}

