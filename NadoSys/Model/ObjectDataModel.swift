//
//  ObjectDataModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/7/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class ObjectDataModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var isScaner: Int = 0
    var objectId: Int = 0
    var objectName: String = ""
    var objectType: String = ""
    var sortby: Int = 0
   
    
    public func mapping(map: Map) {
        isScaner    <- map["isScaner"]
        objectId    <- map["objectId"]
        objectName    <- map["objectName"]
        objectType    <- map["objectType"]
        sortby    <- map["sortby"]
    }
    
}



