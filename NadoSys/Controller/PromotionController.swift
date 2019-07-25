//
//  PromotionController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/18/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import MagicalRecord
import Alamofire
import  SwiftyJSON
import ObjectMapper
public class PromotionController: IPromotion{
    
    var _http: Http?
    
    init() {
        _http = Http()
    }
    
    func InsertPromotion(_ model: PromotionModel) {
        MagicalRecord.save({ (context) in
            if let entity = Promotion.mr_createEntity(in: context){
                entity.shopId = Int32(model.shopId)
                entity.id = Int32(Promotion.mr_countOfEntities() + 1)
                entity.changed = Int32(model.changed)
                entity.employeeId = Int32(model.employeeId)
                entity.brand = Int32(model.brand)
                entity.createdDate = model.createdDate
                entity.reportDate = model.reportDate
                entity.model = model.model
                entity.guid = model.guid
                entity.category = model.category
                entity.promotionName = model.promotionName
                entity.promotionType = Int32(model.promotionType)
                entity.brandName = model.brandName
                entity.changed = 0
            }
        })
    }
    
    
    
    func InsertPromotionImage(_ model: PromotionImageModel,completionHandler: @escaping (Bool?) -> ()) {
        MagicalRecord.save({ (context) in
            if let entity = PromotionImage.mr_createEntity(in: context){
                entity.shopId = Int32(model.shopId)
                entity.id = Int32(PromotionImage.mr_countOfEntities() + 1)
                entity.changed = Int32(model.changed)
                entity.employeeId = Int32(model.employeeId)
                entity.createdDate = model.createdDate
                entity.reportDate = model.reportDate
                entity.guid = model.guid
                entity.urlImage = model.urlImage
                entity.shopName = model.shopName
                entity.changed = 0
            }
            else{
                 completionHandler(false)
            }
        })
        { (success, error) in
            completionHandler(true)
        }
    }
    
    func GetImageList(_ shopId: Int,reportDate: String,empId: Int,guid: String) -> [ImageListModel]? {
        var results = [ImageListModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "reportDate = '\(reportDate)'")
        let predicate1 = NSPredicate(format: "shopId = \(shopId)")
        let predicate2 = NSPredicate(format: "employeeId = '\(empId)'")
        let predicate3 = NSPredicate(format: "guid = '\(guid)'")
        
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3,])
        if let objs = PromotionImage.mr_findAllSorted(by: "id", ascending: true,with: predicateCompound, in: context) as? [PromotionImage]{
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
    
    func GetListImages(_ shopId: Int,reportDate: String,empId: Int,guid: String) -> [PromotionImageModel]? {
        var results = [PromotionImageModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "reportDate = \(reportDate)")
        let predicate1 = NSPredicate(format: "shopId = \(shopId)")
        let predicate2 = NSPredicate(format: "employeeId = '\(empId)'")
        let predicate3 = NSPredicate(format: "guid = '\(guid)'")
        
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3,])
        if let objs = PromotionImage.mr_findAllSorted(by: "id", ascending: true,with: predicateCompound, in: context) as? [PromotionImage]{
            for entity in objs {
                let model = PromotionImageModel()
                model.shopId = Int(entity.shopId)
                if let urlimage = entity.urlImage{
                    model.urlImage = urlimage
                }
                if let guid = entity.guid{
                    model.guid = guid
                }
                if let shopName = entity.shopName{
                    model.shopName = shopName
                }
                if let createdDate = entity.createdDate{
                    model.createdDate = createdDate
                }
                if let reportDate = entity.reportDate{
                    model.reportDate = reportDate
                }
                model.employeeId = Int(entity.employeeId)
                model.changed = Int(entity.changed)
                model.id = Int(entity.id)
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetList(_ shopId: Int,reportDate: String,empId: Int) -> [PromotionModel]? {
        var results = [PromotionModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "reportDate = '\(reportDate)'")
        let predicate1 = NSPredicate(format: "shopId = \(shopId)")
        let predicate2 = NSPredicate(format: "employeeId = '\(empId)'")
        
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2])
        if let objs = Promotion.mr_findAllSorted(by: "id", ascending: true,with: predicateCompound, in: context) as? [Promotion]{
            for entity in objs {
                let model = PromotionModel()
                model.shopId = Int(entity.shopId)
                model.promotionType = Int(entity.promotionType)
                if let brandName = entity.brandName{
                    model.brandName = brandName
                }
                if let guid = entity.guid{
                    model.guid = guid
                }
                if let m = entity.model{
                    model.model = m
                }
                if let category = entity.category{
                    model.category = category
                }
                if let des = entity.des{
                    model.des = des
                }
                if let promotionName = entity.promotionName{
                    model.promotionName = promotionName
                }
                if let createdDate = entity.createdDate{
                    model.createdDate = createdDate
                }
                if let reportDate = entity.reportDate{
                    model.reportDate = reportDate
                }
                model.employeeId = Int(entity.employeeId)
                model.brand = Int(entity.brand)
                model.changed = Int(entity.changed)
                model.id = Int(entity.id)
                results.append(model)
            }
            return results
        }
        return nil
    }
    
}
