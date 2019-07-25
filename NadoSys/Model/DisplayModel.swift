//
//  DisplayModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/10/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//
import ObjectMapper
import Foundation
public class DisplayModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    var id: Int = 0
    var productId: Int = 0
    var shopId: Int = 0
    var employeeId: Int = 0
    var guideLine: Int = 0
    var categoryCode: String = ""
    var type: String = ""
    var reportDateString: String = ""
    var createdDate: Int = 0
    var reportDate: Int = 0
    var price: Double = 0
    var qty: Int = 0
    var competitorId: Int = 0
    var indexGroup: Int = 0
    var guid: String = ""
    var model: String = ""
    var categoryGroup: String = ""
    var groupBy: String = ""
    var isChange: Int = 0
    var changed: Int = 0
    var catorder: Int = 0
    public func mapping(map: Map) {
        id      <- map["id"]
        shopId    <- map["shopId"]
        productId  <- map["productId"]
        guideLine  <- map["guideLine"]
        employeeId      <- map["employeeId"]
        categoryCode      <- map["categoryCode"]
        type    <- map["type"]
        reportDateString  <- map["reportDateString"]
        createdDate  <- map["createdDate"]
        reportDate      <- map["reportDate"]
        price    <- map["price"]
        qty  <- map["qty"]
        competitorId  <- map["competitorId"]
        indexGroup      <- map["indexGroup"]
        guid  <- map["guid"]
        model      <- map["model"]
        categoryGroup    <- map["categoryGroup"]
        isChange  <- map["isChange"]
        changed  <- map["changed"]
    }
    
}
