//
//  SellOutModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/22/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class SellOutModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    
    }
    var barcode: String = ""
    var guid: String = ""
    var orderCode: String = ""
    var objId: Int = 0
    var id: Int = 0
    var cusName: String = ""
    var cusPhone: String = ""
    var cusAdd: String = ""
    var productName: String = ""
    var model: String = ""
    var createDate: String = ""
    var price: Double = 0
    var qty: Int = 0
    var changed: Int = 0
    var productId: Int = 0
    var shopId: Int = 0
    var dealerId: Int = 0
    var saleDate: String = ""
    var saleDate2: String = ""
    var employeeId: Int = 0
    var blockStatus: Int = 0
    public func mapping(map: Map) {
         barcode    <- map["barcode"]
         guid    <- map["guid"]
        model    <- map["model"]
        orderCode    <- map["orderCode"]
        objId    <- map["objId"]
        cusName    <- map["cusName"]
        cusPhone    <- map["cusPhone"]
        id    <- map["id"]
        createDate    <- map["createDate"]
        price    <- map["price"]
        qty    <- map["qty"]
        changed    <- map["changed"]
        productId    <- map["productId"]
        dealerId    <- map["dealerId"]
        saleDate    <- map["saleDate"]
        saleDate2    <- map["saleDate2"]
        productName    <- map["productName"]
        employeeId    <- map["employeeId"]
        shopId    <- map["shopId"]
        blockStatus    <- map["blockStatus"]
    }
    
}


