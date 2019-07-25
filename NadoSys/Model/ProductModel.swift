//
//  ProductModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/7/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class ProductModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    var guideLine: Int = 0
    var capacity: String = ""
    var barcode: String = ""
    var sapcode: String = ""
    var guid: String = ""
    var categoryCode: String = ""
    var categoryName: String = ""
    var createdDate: String = ""
    var subCat1: String = ""
    var subCat2: String = ""
    var subCat3: String = ""
    var subCat4: String = ""
    var deleted: Int = 0
    var isNew: Int = 0
    var model: String = ""
    var keymodels: String = ""
    var urlImage: String = ""
    var productId: Int = 0
    var quantity: Int = 0
    var price: Double = 0
    var isCheck: Int = 0
    var isScan: Int = 0
    var status: Int = 0
    var total: Int = 0
    var ordercate: Int = 0
    public func mapping(map: Map) {
        guid    <- map["guid"]
        barcode    <- map["barcode"]
        capacity    <- map["capacity"]
        categoryCode    <- map["categoryCode"]
        categoryName    <- map["categoryName"]
        createdDate    <- map["createdDate"]
        subCat1    <- map["subCat1"]
        subCat2    <- map["subCat2"]
        subCat3    <- map["subCat3"]
        subCat4    <- map["subCat4"]
        keymodels    <- map["keymodels"]
        deleted    <- map["deleted"]
        isNew    <- map["isNew"]
        model    <- map["model"]
        status    <- map["status"]
        productId    <- map["productId"]
        quantity    <- map["quantity"]
        price    <- map["price"]
        sapcode    <- map["price"]
    }
    
}


