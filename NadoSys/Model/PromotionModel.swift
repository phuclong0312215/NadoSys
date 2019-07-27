//
//  PromotionModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/18/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class PromotionModel: NSObject, Mappable,Codable{
    var id: Int = 0
    var titleId: Int = 0
    var employeeId: Int = 0
    var shopId: Int = 0
    var changed: Int = 0
    var reportDate: String = ""
    var createdDate: String = ""
    var brand: Int = 0
    var des: String = ""
    var promotionName: String = ""
    var promotionType: Int = 0
    var brandName: String = ""
    var guid: String = ""
    var model: String = ""
    var category: String = ""
    var price: Double = 0
    var gift: String = ""
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        employeeId            <- map["employeeId"]
        id    <- map["id"]
        titleId    <- map["titleId"]
        shopId    <- map["shopId"]
        guid    <- map["guid"]
        changed    <- map["changed"]
        reportDate    <- map["reportDate"]
        createdDate    <- map["createdDate"]
        model    <- map["model"]
        brand    <- map["brand"]
        des    <- map["des"]
        promotionName    <- map["promotionName"]
        promotionType    <- map["promotionType"]
        brandName    <- map["brandName"]
        category    <- map["category"]
        price    <- map["price"]
        gift    <- map["gift"]
    }
}

