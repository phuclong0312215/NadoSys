//
//  POSMModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/20/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//
import Foundation
import ObjectMapper
import SwiftyJSON
public class POSMModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
   
    var itemCode: String = ""
    var cat: String = ""
    var position: String = ""
    var posmType: String = ""
    var cap: String = ""
    var itemName: String = ""
    var createdDate: String = ""
    var quantity: Int = 0
    var reportDate: String = ""
    var shopId: Int = 0
    var employeeId: Int = 0
    var posmId: Int = 0
    var sortlist: Int = 0
    var active: Int = 0
    var id: Int = 0
    var isCheck: Int = 0
    public func mapping(map: Map) {
        itemName    <- map["itemName"]
        itemCode    <- map["itemCode"]
        cat    <- map["cat"]
        position    <- map["position"]
        posmType    <- map["posmType"]
        cap    <- map["cap"]
        createdDate    <- map["createdDate"]
        quantity    <- map["quantity"]
        reportDate    <- map["reportDate"]
        posmId    <- map["posmId"]
        sortlist    <- map["sortlist"]
        active    <- map["active"]
        id    <- map["id"]
        employeeId    <- map["employeeId"]
        shopId    <- map["shopId"]
    }
    
}

