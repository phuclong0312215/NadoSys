//
//  ImageListController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/15/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import MagicalRecord
public class ImageListController: IImageList{
    
    var _dataOfflineController: IDataOffline
    init(dataOfflineController: IDataOffline) {
        _dataOfflineController = dataOfflineController
    }
    
    
    func GetListUploads(_ competitorId: Int,shopId: Int,reportDate: Int,imageType: Int,empId: Int) -> [ImageListModel]? {
        var results = [ImageListModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "reportdate = \(Date().toIntShortDate())")
        let predicate1 = NSPredicate(format: "competitorid = \(competitorId)")
        let predicate2 = NSPredicate(format: "shopid = '\(shopId)'")
        let predicate3 = NSPredicate(format: "empid = '\(empId)'")
        let predicate4 = NSPredicate(format: "imagetype = '\(imageType)'")
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3,predicate4])
        if let objs = ImageList.mr_findAllSorted(by: "createddate", ascending: true,with: predicateCompound, in: context) as? [ImageList]{
            for entity in objs {
                let model = ImageListModel()
                model.shopId = Int(entity.shopid)
                if let urlimage = entity.urlimage{
                    model.urlimage = urlimage
                }
                if let categorycode = entity.categorycode{
                    model.categorycode = categorycode
                }
                model.productId = Int(entity.productid)
                model.empId = Int(entity.empid)
                model.competitorId = Int(entity.competitorid)
                model.changed = Int(entity.changed)
                model.imageType = Int(entity.imagetype)
                model.reportdate = Int(entity.reportdate)
                model.createddate = entity.createddate
                results.append(model)
            }
            return results
        }
        return nil
    }
    func GetListUploadDisplay(_ competitorId: Int,shopId: Int,reportDate: Int,imageType: Int,empId: Int) -> [ImageListModel]? {
        var results = [ImageListModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "reportdate = \(Date().toIntShortDate())")
        let predicate1 = NSPredicate(format: "competitorid = \(competitorId)")
        let predicate2 = NSPredicate(format: "shopid = '\(shopId)'")
        let predicate3 = NSPredicate(format: "empid = '\(empId)'")
        let predicate4 = NSPredicate(format: "imagetype = '\(imageType)' OR imagetype = '1020'")
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3,predicate4])
        if let objs = ImageList.mr_findAllSorted(by: "createddate", ascending: true,with: predicateCompound, in: context) as? [ImageList]{
            for entity in objs {
                let model = ImageListModel()
                model.shopId = Int(entity.shopid)
                if let urlimage = entity.urlimage{
                    model.urlimage = urlimage
                }
                if let categorycode = entity.categorycode{
                    model.categorycode = categorycode
                }
                model.productId = Int(entity.productid)
                model.empId = Int(entity.empid)
                model.competitorId = Int(entity.competitorid)
                model.changed = Int(entity.changed)
                model.imageType = Int(entity.imagetype)
                model.reportdate = Int(entity.reportdate)
                model.createddate = entity.createddate
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetLists(_ competitorId: Int,shopId: Int,reportDate: Int,imageType: Int,empId: Int,categoryCode: String) -> [ImageListModel]? {
        var results = [ImageListModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "reportdate = \(Date().toIntShortDate())")
        let predicate1 = NSPredicate(format: "competitorid = \(competitorId)")
        let predicate2 = NSPredicate(format: "shopid = '\(shopId)'")
        let predicate3 = NSPredicate(format: "empid = '\(empId)'")
        let predicate4 = NSPredicate(format: "imagetype = '\(imageType)'")
        let predicate5 = NSPredicate(format: "categorycode = '\(categoryCode)'")
         var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3,predicate4,predicate5])
        if let objs = ImageList.mr_findAllSorted(by: "createddate", ascending: true,with: predicateCompound, in: context) as? [ImageList]{
            for entity in objs {
                let model = ImageListModel()
                model.shopId = Int(entity.shopid)
                if let urlimage = entity.urlimage{
                    model.urlimage = urlimage
                }
                if let categorycode = entity.categorycode{
                    model.categorycode = categorycode
                }
                model.productId = Int(entity.productid)
                model.empId = Int(entity.empid)
                model.competitorId = Int(entity.competitorid)
                model.changed = Int(entity.changed)
                model.imageType = Int(entity.imagetype)
                model.reportdate = Int(entity.reportdate)
                model.createddate = entity.createddate
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetListSellOut(_ productguid: String) -> [ImageListModel]? {
        var results = [ImageListModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "productguid = '\(productguid)'")
//        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3,predicate4,predicate5])
        if let objs = ImageList.mr_findAllSorted(by: "createddate", ascending: true,with: predicate, in: context) as? [ImageList]{
            for entity in objs {
                let model = ImageListModel()
                model.shopId = Int(entity.shopid)
                if let urlimage = entity.urlimage{
                    model.urlimage = urlimage
                }
                if let categorycode = entity.categorycode{
                    model.categorycode = categorycode
                }
                model.productId = Int(entity.productid)
                model.empId = Int(entity.empid)
                model.competitorId = Int(entity.competitorid)
                model.changed = Int(entity.changed)
                model.imageType = Int(entity.imagetype)
                model.reportdate = Int(entity.reportdate)
                model.createddate = entity.createddate
                if let barcode = entity.barcode{
                    model.barcode = barcode
                }
                if let m = entity.model{
                    model.model = m
                }
                if let productguid = entity.productguid{
                    model.productguid = productguid
                }
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    
    func Insert(_ model: ImageListModel,completionHandler: @escaping (Bool?) -> ()) {
        MagicalRecord.save({ (context) in
            if let entity = ImageList.mr_createEntity(in: context){
                entity.shopid = Int32(model.shopId)
                entity.productid = Int32(model.productId)
                entity.competitorid = Int32(model.competitorId)
                entity.empid = Int32(model.empId)
                entity.createddate = model.createddate
                entity.reportdate = Int32(model.reportdate)
                entity.categorycode = model.categorycode
                entity.changed = Int32(model.changed)
                entity.imagetype = Int32(model.imageType)
                entity.model = model.model
                entity.productguid = model.productguid
                entity.barcode = model.barcode
                entity.urlimage = model.urlimage
            }
            else{
                completionHandler(true)
            }
        })
        { (success, error) in
            completionHandler(true)
        }
    }
    
    func InsertList(_ list: [ImageListModel]) {
        MagicalRecord.save({ (context) in
            for model in list {
                if let entity = ImageList.mr_createEntity(in: context){
                    entity.shopid = Int32(model.shopId)
                    entity.productid = Int32(model.productId)
                    entity.competitorid = Int32(model.competitorId)
                    entity.empid = Int32(model.empId)
                    entity.createddate = model.createddate
                    entity.reportdate = Int32(model.reportdate)
                    entity.categorycode = model.categorycode
                    entity.changed = Int32(model.changed)
                    entity.imagetype = Int32(model.imageType)
                    entity.model = model.model
                    entity.productguid = model.productguid
                    entity.barcode = model.barcode
                    entity.urlimage = model.urlimage
                }
            }
        })
        
    }
}
