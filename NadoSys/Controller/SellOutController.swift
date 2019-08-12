//
//  SellOutController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/22/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import MagicalRecord
public class SellOutController: ISellOut {
    
    var _dataOfflineController: IDataOffline
    init(dataOfflineController: IDataOffline) {
        _dataOfflineController = dataOfflineController
    }
    
    func GetList(_ shopId: Int,empId: Int,saleDate: String,objId: Int) -> [SellOutModel]? {
        var results = [SellOutModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "saleDate = '\(saleDate)'")
        let predicate1 = NSPredicate(format: "shopId = '\(shopId)'")
        let predicate2 = NSPredicate(format: "employeeId = '\(empId)'")
        let predicate3 = NSPredicate(format: "objId = '\(objId)'")
        let predicate4 = NSPredicate(format: "productId <> -1")
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3,predicate4])
        
        if let sellouts = SellOut.mr_findAllSorted(by: "id",ascending: true,with: predicateCompound, in: context) as? [SellOut]{
            for entity in sellouts {
                let model = SellOutModel()
                model.productId = Int(entity.productId)
                model.id = Int(entity.id)
                model.employeeId = Int(entity.employeeId)
                if let orderCode = entity.orderCode{
                    model.orderCode = orderCode
                }
                model.blockStatus = Int(entity.blockStatus)
                model.price = entity.price
                model.qty = Int(entity.qty)
                model.dealerId = Int(entity.dealerId)
                model.shopId = Int(entity.shopId)
                if let cusPhone = entity.cusPhone{
                    model.cusPhone = cusPhone
                }
                if let cusName = entity.cusName{
                    model.cusName = cusName
                }
                if let cusAdd = entity.cusAdd{
                    model.cusAdd = cusAdd
                }
                if let saleDate = entity.saleDate{
                    model.saleDate = saleDate
                }
                if let createdDate = entity.createdDate{
                    model.createDate = createdDate
                }
                if let m = entity.model{
                    model.model = m
                }
                if let barcode = entity.barcode{
                    model.barcode = barcode
                }
                model.changed = Int(entity.changed)
                model.objId = Int(entity.objId)
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    // Hưng thêm
    func GetNosell(_ shopId: Int, empId: Int, saleDate: String, objId: Int) -> [SellOutModel]? {
        var results = [SellOutModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "saleDate = '\(saleDate)'")
        let predicate1 = NSPredicate(format: "shopId = '\(shopId)'")
        let predicate2 = NSPredicate(format: "employeeId = '\(empId)'")
        let predicate3 = NSPredicate(format: "objId = '\(objId)'")
        let predicate4 = NSPredicate(format: "productId = -1")
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3,predicate4])
        
        if let sellouts = SellOut.mr_findAllSorted(by: "id",ascending: true,with: predicateCompound, in: context) as? [SellOut]{
            for entity in sellouts {
                let model = SellOutModel()
                model.productId = Int(entity.productId)
                model.id = Int(entity.id)
                model.employeeId = Int(entity.employeeId)
                if let orderCode = entity.orderCode{
                    model.orderCode = orderCode
                }
                model.blockStatus = Int(entity.blockStatus)
                model.price = entity.price
                model.qty = Int(entity.qty)
                model.dealerId = Int(entity.dealerId)
                model.shopId = Int(entity.shopId)
                if let cusPhone = entity.cusPhone{
                    model.cusPhone = cusPhone
                }
                if let cusName = entity.cusName{
                    model.cusName = cusName
                }
                if let cusAdd = entity.cusAdd{
                    model.cusAdd = cusAdd
                }
                if let saleDate = entity.saleDate{
                    model.saleDate = saleDate
                }
                if let createdDate = entity.createdDate{
                    model.createDate = createdDate
                }
                if let m = entity.model{
                    model.model = m
                }
                if let barcode = entity.barcode{
                    model.barcode = barcode
                }
                model.changed = Int(entity.changed)
                model.objId = Int(entity.objId)
                results.append(model)
            }
                return results
        }
        return nil
    }
    func Insert(_ list: [SellOutModel]) {
        MagicalRecord.save({ (context) in
            for model in list {
                if let entity = SellOut.mr_createEntity(in: context){
                    entity.shopId = Int32(model.shopId)
                    entity.productId = Int32(model.productId)
                    entity.cusAdd = model.cusAdd
                    entity.cusName = model.cusName
                    entity.cusPhone = model.cusPhone
                    entity.model = model.model
                    entity.employeeId = Int32(model.employeeId)
                    entity.saleDate = model.saleDate
                    entity.createdDate = model.createDate
                    entity.dealerId = Int32(model.dealerId)
                    entity.qty = Int32(model.qty)
                    entity.blockStatus = Int32(model.blockStatus)
                    entity.price = model.price
                    entity.objId = Int32(model.objId)
                    entity.orderCode = model.orderCode
                    entity.id =  Int32(SellOut.mr_countOfEntities() + 1)
                    entity.changed = 0
                }
            }
        })
    }
}
