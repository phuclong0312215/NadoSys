//
//  AttandanceController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/24/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import MagicalRecord
import Alamofire
import  SwiftyJSON
import ObjectMapper
public class AttandanceController: IAttandance{
    
    var _http: Http?
    
    init() {
        _http = Http()
    }
    func GetByType(_ shopId: Int,empId: Int,attandanceDate: String,aType: String) -> AttandanceModel? {
        var results = [ObjectDataModel]()
        let predicate = NSPredicate(format: "shopid = '\(shopId)'")
        let predicate1 = NSPredicate(format: "employeeid = '\(empId)'")
        let predicate2 = NSPredicate(format: "atype = '\(aType)'")
        let predicate3 = NSPredicate(format: "attendancedate = '\(attandanceDate)'")
        let context = NSManagedObjectContext.mr_()
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3])
        if let entity = Attendance.mr_findFirst(with: predicateCompound, in: context){
            let model = AttandanceModel()
            model.empid = Int(entity.employeeid)
            model.latitude = entity.latitude
            model.longitude = entity.longitude
            model.accuracy = entity.accuracy
            model.blockstatus = Int(entity.blockstatus)
            model.isdeleted = Int(entity.isdeleted)
            model.ischange = Int(entity.ischange)
            model.shopid = Int(entity.shopid)
            if let guiid = entity.guiid{
                model.guidid = guiid
            }
            if let atype = entity.atype{
                model.atype = atype
            }
            if let photo = entity.photo{
                model.photo = photo
            }
            if let shopname = entity.shopname{
                model.shopname = shopname
            }
            if let attendancedate = entity.attendancedate{
                model.attendancedate = attendancedate
            }
            if let createdate = entity.createdate{
                model.createddate = createdate
            }
            return model
        }
        return nil
    }
    
    func InsertAttandance(_ model: AttandanceModel,completionHandler: @escaping (Bool?) -> ()) {
        MagicalRecord.save({ (context) in
            if let entity = Attendance.mr_createEntity(in: context){
                entity.shopid = Int32(model.shopid)
                entity.atype = model.atype
                entity.id = Int32(Promotion.mr_countOfEntities() + 1)
                entity.employeeid = Int32(model.empid)
                entity.latitude = model.latitude
                entity.longitude = model.longitude
                entity.createdate = model.createddate
                entity.blockstatus = Int32(model.blockstatus)
                entity.photo = model.photo
                entity.shopname = model.shopname
                entity.attendancedate = model.attendancedate
                entity.isdeleted = 0
                entity.ischange = 0
                entity.guiid = UUID().uuidString
            }
            else{
                completionHandler(false)
            }
        })
        { (success, error) in
            completionHandler(true)
        }
    }
}

