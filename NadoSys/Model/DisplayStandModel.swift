//
//  DisplayStandModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/19/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//
import Foundation
import ObjectMapper
public class DisplayStandModel: NSObject, Mappable,Codable{
    var id: Int = 0
    var employeeId: Int = 0
    var shopId: Int = 0
    var changed: Int = 0
    var reportDate: String = ""
    var createdDate: String = ""
    var statusName: String = ""
    var posmName: String = ""
    var barcode: String = ""
    var posmId: Int = 0
    var qty: Int = 0
    var status: Int = 0
    var note: String = ""
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        employeeId            <- map["employeeId"]
        id    <- map["id"]
        shopId    <- map["shopId"]
        changed    <- map["changed"]
        reportDate    <- map["reportDate"]
        createdDate    <- map["createdDate"]
        statusName    <- map["statusName"]
        posmName    <- map["posmName"]
        barcode    <- map["barcode"]
        posmId    <- map["posmId"]
        qty    <- map["qty"]
        status    <- map["status"]
        note    <- map["note"]
    }
}


