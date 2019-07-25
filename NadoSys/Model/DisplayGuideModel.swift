//
//  DisplayGuideModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/8/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class DisplayGuideModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    var id: Int = 0
    var shopId: Int = 0
    var productId: Int = 0
    var guideLine: Int = 0
    var photo: String = ""
   
    public func mapping(map: Map) {
        id      <- map["id"]
        shopId    <- map["shopId"]
        productId  <- map["productId"]
        guideLine  <- map["guideLine"]
        photo      <- map["photo"]
    }
    
}





