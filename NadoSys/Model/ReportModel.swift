//
//  ReportModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/9/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON
public class EmployeeAvgModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var amount: Int = 0
    var objectName: String = ""
    var ihsAmount: String = ""
    var displayShare: Int = 0
    var displayWM: Int = 0
    var displayREF: Int = 0
    var displayAC: Int = 0
    var sellYearAchieved: Int = 0
    public func mapping(map: Map) {
        amount    <- map["amount"]
        objectName    <- map["objectName"]
        ihsAmount    <- map["ihsAmount"]
        displayShare    <- map["displayShare"]
        displayWM    <- map["displayWM"]
        displayREF    <- map["displayREF"]
        displayAC    <- map["displayAC"]
        sellYearAchieved    <- map["sellYearAchieved"]
    }
    
}
public class DisplayFixModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var objectId: Int = 0
    var objectType: String = ""
    var objectName: String = ""
    var quantity: Int = 0
    var noofShop: Int = 0
    var sortby: Int = 0
    
    public func mapping(map: Map) {
        objectId    <- map["objectId"]
        objectType    <- map["objectType"]
        objectName    <- map["objectName"]
        quantity    <- map["quantity"]
        noofShop    <- map["noofShop"]
        sortby    <- map["sortby"]
    }
    
}
public class SellOutReportModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var shopId: Int = 0
    var shopCode: String = ""
    var shopName_nosign: String = ""
    var shopName: String = ""
    var target: Double = 0
    var quantity: Int = 0
    var amount: Double = 0
    var per: Double = 0
    var sort: Int = 0
    
    public func mapping(map: Map) {
        shopId    <- map["shopId"]
        shopCode    <- map["shopCode"]
        shopName_nosign    <- map["shopName_nosign"]
        shopName    <- map["shopName"]
        target    <- map["target"]
        quantity    <- map["quantity"]
        amount    <- map["amount"]
        per    <- map["per"]
        sort    <- map["sort"]
    }
    
}
public class SellOutReportDetailModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var orderCode: String = ""
    var categoryCode: String = ""
    var cusName: String = ""
    var cusPhone: String = ""
    var cussAdd: String = ""
    var barcode: String = ""
    var model: String = ""
    var dateString: String = ""
    var price: Double = 0
    var quantity: Int = 0
    var amount: Double = 0
    var items = JSON()
    public func mapping(map: Map) {
        orderCode    <- map["orderCode"]
        categoryCode    <- map["categoryCode"]
        cusName    <- map["cusName"]
        cusPhone    <- map["cusPhone"]
        cussAdd    <- map["cussAdd"]
        barcode    <- map["barcode"]
        model    <- map["model"]
        dateString    <- map["dateString"]
        price    <- map["price"]
        quantity    <- map["quantity"]
        amount    <- map["amount"]
        items    <- map["items"]
    }
    
}
public class EmployeeAttModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var employeeId: Int = 0
    var employeeCode: String = ""
    var employeeName: String = ""
    var mobile: String = ""
    var avatar: String = ""
    var position: String = ""
    var mon: String = ""
    var tue: String = ""
    var wed: String = ""
    var thu: String = ""
    var fri: String = ""
    var sat: String = ""
    var sun: String = ""
    public func mapping(map: Map) {
        employeeId    <- map["employeeId"]
        employeeCode    <- map["employeeCode"]
        employeeName    <- map["employeeName"]
        mobile    <- map["mobile"]
        avatar    <- map["avatar"]
        position    <- map["position"]
        mon    <- map["mon"]
        tue    <- map["tue"]
        wed    <- map["wed"]
        thu    <- map["thu"]
        fri    <- map["fri"]
        sat    <- map["sat"]
        sun    <- map["sun"]
    }
    
}

