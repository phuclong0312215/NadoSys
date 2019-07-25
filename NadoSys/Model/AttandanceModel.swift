//
//  AttandanceModel.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/7/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import ObjectMapper
public class AttandanceModel: NSObject, Mappable,Codable{
    required convenience public init?(map: Map) {
        self.init()
    }
    
    var accuracy: Double = 0
    var attendancedate: String = ""
    var atype: String = ""
    var autodate: Int = 0
    var blockstatus: Int = 0
    var comments: String = ""
    var createddate: String = ""
    var guidid: String = ""
    var id: Int = 0
    var empid: Int = 0
    var ischange: Int = 0
    var isdeleted: Int = 0
    var latitude: Double = 0
    var longitude: Double = 0
    var photo: String = ""
    var shifttype: String = ""
    var shopname: String = ""
    var shopid: Int = 0
    var timing: Int = 0
    var timingstring: String = ""
    
    public func mapping(map: Map) {
        accuracy            <- map["accuracy"]
        attendancedate    <- map["attendancedate"]
        atype    <- map["atype"]
        autodate    <- map["autodate"]
        blockstatus    <- map["blockstatus"]
        comments    <- map["comments"]
        createddate    <- map["createddate"]
        guidid    <- map["guidid"]
        id    <- map["id"]
        ischange    <- map["ischange"]
        isdeleted    <- map["isdeleted"]
        latitude    <- map["latitude"]
        longitude    <- map["longitude"]
        photo    <- map["photo"]
        shifttype    <- map["shifttype"]
        shopname    <- map["shopname"]
        shopid    <- map["shopid"]
        timing    <- map["timing"]
        timingstring    <- map["timingstring"]
    }
    
}
