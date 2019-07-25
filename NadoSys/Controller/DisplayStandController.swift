//
//  DisplayStandController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/19/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import MagicalRecord
import Alamofire
import  SwiftyJSON
import ObjectMapper
public class DisplayStandController: IDisplayStand{
    func GetList(_ shopId: Int, reportDate: String, empId: Int) -> [DisplayStandModel]? {
        var results = [DisplayStandModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "reportDate = '\(reportDate)'")
        let predicate1 = NSPredicate(format: "shopId = \(shopId)")
        let predicate2 = NSPredicate(format: "employeeId = '\(empId)'")
        
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2])
        if let objs = DisplayStand.mr_findAllSorted(by: "id", ascending: true,with: predicateCompound, in: context) as? [DisplayStand]{
            for entity in objs {
                let model = DisplayStandModel()
                model.shopId = Int(entity.shopId)
                model.status = Int(entity.status)
                if let barcode = entity.barcode{
                    model.barcode = barcode
                }
                if let statusName = entity.statusName{
                    model.statusName = statusName
                }
                if let posmName = entity.posmName{
                    model.posmName = posmName
                }
                if let note = entity.note{
                    model.note = note
                }
                if let createdDate = entity.createdDate{
                    model.createdDate = createdDate
                }
                if let reportDate = entity.reportDate{
                    model.reportDate = reportDate
                }
                model.employeeId = Int(entity.employeeId)
                model.posmId = Int(entity.posmId)
                model.qty = Int(entity.qty)
                model.changed = Int(entity.changed)
                model.id = Int(entity.id)
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetImageList(_ shopId: Int, reportDate: String, posmId: Int,empId: Int) -> [ImageListModel]? {
        var results = [ImageListModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "reportDate = '\(reportDate)'")
        let predicate1 = NSPredicate(format: "shopId = \(shopId)")
        let predicate2 = NSPredicate(format: "employeeId = '\(empId)'")
        let predicate3 = NSPredicate(format: "posmId = '\(posmId)'")
        
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3,])
        if let objs = DisplayStandImage.mr_findAllSorted(by: "id", ascending: true,with: predicateCompound, in: context) as? [DisplayStandImage]{
            for entity in objs {
                let model = ImageListModel()
                model.shopId = Int(entity.shopId)
                if let urlimage = entity.urlImage{
                    model.urlimage = urlimage
                }
                model.empId = Int(entity.employeeId)
                model.changed = Int(entity.changed)
                model.id = Int(entity.id)
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func InsertStandImage(_ model: DisplayStandImageModel, completionHandler: @escaping (Bool?) -> ()) {
        MagicalRecord.save({ (context) in
            if let entity = DisplayStandImage.mr_createEntity(in: context){
                entity.shopId = Int32(model.shopId)
                entity.id = Int32(PromotionImage.mr_countOfEntities() + 1)
                entity.changed = Int32(model.changed)
                entity.employeeId = Int32(model.employeeId)
                entity.standId = Int32(model.standId)
                entity.createdDate = model.createdDate
                entity.reportDate = model.reportDate
                entity.timing = model.timing
                entity.shopName = model.shopName
                entity.urlImage = model.urlImage
                entity.posmId = Int32(model.posmId)
            }
            else{
                completionHandler(false)
            }
        })
        { (success, error) in
            completionHandler(true)
        }
    }
    
    func InsertStand(_ model: DisplayStandModel) {
        MagicalRecord.save({ (context) in
            if let entity = DisplayStand.mr_createEntity(in: context){
                entity.shopId = Int32(model.shopId)
                entity.id = Int32(Promotion.mr_countOfEntities() + 1)
                entity.changed = Int32(model.changed)
                entity.employeeId = Int32(model.employeeId)
                entity.createdDate = model.createdDate
                entity.reportDate = model.reportDate
                entity.posmName = model.posmName
                entity.barcode = model.barcode
                entity.statusName = model.statusName
                entity.status = Int32(model.status)
                entity.posmId = Int32(model.posmId)
                entity.qty = Int32(model.qty)
                entity.note = model.note
                entity.changed = 0
            }
        })
    }
    
    
    var _http: Http?
    
    init() {
        _http = Http()
    }
}
