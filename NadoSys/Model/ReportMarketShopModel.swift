//
//  ReportMarketShopModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/5/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class ReportMarketShopModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
        
    }
    var title: String = ""
    var objectName: String = ""
    var objectId: Int = 0
    var noofShop: Int = 0
    var noofPS: Int = 0
    var noofME: Int = 0
    var noofLSR: Int = 0
    var orderBy: Int = 0
    var area: String = ""
    var groupBy: String = ""
    public func mapping(map: Map) {
        title    <- map["title"]
        objectName    <- map["objectName"]
        objectId    <- map["objectId"]
        noofShop    <- map["noofShop"]
        noofPS    <- map["noofPS"]
        noofME    <- map["noofME"]
        noofLSR    <- map["noofLSR"]
        orderBy    <- map["orderBy"]
        area    <- map["area"]
    }
    
}



