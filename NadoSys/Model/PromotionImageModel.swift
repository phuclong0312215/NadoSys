//
//  PromotionImage.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/18/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class PromotionImageModel: NSObject, Mappable,Codable{
    var id: Int = 0
    var employeeId: Int = 0
    var shopId: Int = 0
    var changed: Int = 0
    var reportDate: String = ""
    var createdDate: String = ""
    var shopName: String = ""
    var urlImage: String = ""
    var guid: String = ""
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        employeeId            <- map["employeeId"]
        id    <- map["id"]
        shopId    <- map["shopId"]
        guid    <- map["guid"]
        changed    <- map["changed"]
        reportDate    <- map["reportDate"]
        createdDate    <- map["createdDate"]
        shopName    <- map["shopName"]
        urlImage    <- map["urlImage"]
    }
}
