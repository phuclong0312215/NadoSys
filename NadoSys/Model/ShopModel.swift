//
//  ShopModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/7/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON
public class ShopModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    var isWait: Int = 0
    var newCode: String = ""
    var shopName_nosign: String = ""
    var address_nosign: String = ""
    var regionId: Int = 0
    var districtId: Int = 0
    var wardId: Int = 0
    var provinceId: Int = 0
    var objectId: Int = 0
    var objectName: String = ""
    var channel: String = ""
    var channelType: String = ""
    var ward: String = ""
    var pic: String = ""
    var street: String = ""
    var village: String = ""
    var noofHouse: String = ""
    var city: String = ""
    var address: String = ""
    var area: String = ""
    var district: String = ""
    var id: Int = 0
    var inputtype: String = ""
    var isdeleted: Int = 0
    var objectid: String = ""
    var orderby: Int = 0
    var latitude: Double = 0
    var longitude: Double = 0
    var region: String = ""
    var shopCode: String = ""
    var shopId: Int = 0
    var outletID: Int = 0
    var shopName: String = ""
    var shopname_en: String = ""
    var reportDate: String = ""
    var jsonvalue: String = ""
    var item = JSON()
    var employeeId: Int = 0
    var isCheck: Int = 0
    public func mapping(map: Map) {
        isWait    <- map["isWait"]
        newCode    <- map["newCode"]
        shopName_nosign    <- map["shopName_nosign"]
        address_nosign    <- map["address_nosign"]
        regionId    <- map["regionId"]
        districtId    <- map["districtId"]
         wardId    <- map["wardId"]
         provinceId    <- map["provinceId"]
         objectId    <- map["objectId"]
         objectName    <- map["objectName"]
         channel    <- map["channel"]
         channelType    <- map["channelType"]
         ward    <- map["ward"]
         pic    <- map["pic"]
         street    <- map["street"]
         village    <- map["village"]
         noofHouse    <- map["noofHouse"]
        item    <- map["attributes"]
        jsonvalue    <- map["jsonvalue"]
        reportDate    <- map["reportDate"]
        outletID    <- map["outletID"]
        employeeId    <- map["employeeId"]
        address    <- map["address"]
        area    <- map["area"]
        city    <- map["city"]
        district    <- map["district"]
        id    <- map["id"]
        inputtype    <- map["inputtype"]
        isdeleted    <- map["isdeleted"]
        objectid    <- map["objectid"]
        orderby    <- map["orderby"]
        latitude    <- map["latitude"]
        longitude    <- map["longitude"]
        region    <- map["region"]
        shopCode    <- map["shopCode"]
        employeeId    <- map["employeeId"]
        shopId    <- map["shopId"]
        shopName    <- map["shopName"]
        shopname_en    <- map["shopname_en"]
    }
    
}

