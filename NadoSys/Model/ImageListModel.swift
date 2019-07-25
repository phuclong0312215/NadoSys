//
//  ImageListModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/15/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class ImageListModel: NSObject, Mappable,Codable{
    var empId: Int = 0
    var id: Int = 0
    var productId: Int = 0
    var shopId: Int = 0
    var competitorId: Int = 0
    var changed: Int = 0
    var imageType: Int = 0
    var reportdate: Int = 0
    var createddate: Int64 = 0
    var categorycode: String = ""
    var urlimage: String = ""
    var barcode: String = ""
    var productguid: String = ""
    var model: String = ""
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        id            <- map["id"]
        empId            <- map["empId"]
        productId            <- map["productId"]
        shopId    <- map["shopId"]
        competitorId    <- map["competitorId"]
        changed    <- map["changed"]
        imageType    <- map["imageType"]
        reportdate    <- map["reportdate"]
        createddate    <- map["createddate"]
        categorycode    <- map["categorycode"]
        urlimage    <- map["urlimage"]
        model    <- map["model"]
        productguid    <- map["productguid"]
        barcode    <- map["barcode"]
    }
}
