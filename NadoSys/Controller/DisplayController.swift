//
//  DisplayController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/10/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import MagicalRecord
public class DisplayController: IDisplay{
    
    var _dataOfflineController: IDataOffline
    init(dataOfflineController: IDataOffline) {
        _dataOfflineController = dataOfflineController
    }
    
    func getModelByCompetitor(_ shopId: Int,empId: Int,competitorId: Int) -> [DisplayModel]? {
        var lstDisplayResults = [DisplayModel]()
        var lstModel: [ProductModel]?
        let lstDisplay = getListDisplayModel(shopId,empId: empId,competitorId: competitorId)
        if lstDisplay != nil && (lstDisplay?.count)! > 0 {
            if lstDisplay![0].reportDate == Date().toIntShortDate(){
                return lstDisplay
            }
            for item in lstDisplay!{
                item.reportDate = Date().toIntShortDate()
            }
            Insert(lstDisplay)
            return lstDisplay
        }
        lstModel = _dataOfflineController.GetListProductByGuideLine(shopId)
        if let displays = lstModel{
            for prod in displays{
                if prod.model != "" {
                    let item = DisplayModel()
                    item.reportDate = Date().toIntShortDate()
                    item.productId = prod.productId
                    item.guideLine = prod.guideLine
                    item.employeeId = empId
                    item.categoryCode = prod.categoryCode
                    item.model = prod.model
                    item.price = prod.price
                    item.competitorId = competitorId
                    item.shopId = shopId
                    if lstDisplay == nil {
                        item.qty = 0
                    }
                    else{
                        let display = lstDisplay?.first{$0.model == item.model}
                        if let qty = display?.qty {
                            item.qty = qty
                        }
                    }
                    lstDisplayResults.append(item)
                }
            }
            Insert(lstDisplayResults)
            return lstDisplayResults
            
        }
        return nil
    }
    
    
    func getCategoryByCompetitor(_ competitorId: Int,shopId: Int,empId: Int) -> [DisplayModel]? {
        var lstDisplayResults = [DisplayModel]()
        var lstCategory: [ProductModel]?
        let lstDisplay = getListDisplay(competitorId,shopId: shopId,empId: empId)
        if lstDisplay != nil && (lstDisplay?.count)! > 0 {
            return lstDisplay
        }
        lstCategory = _dataOfflineController.GetCategory()
        if let displays = lstCategory{
            for prod in displays{
                if prod.categoryCode != "" {
                    let item = DisplayModel()
                    item.productId = 0
                    item.guideLine = 0
                    item.employeeId = empId
                    item.categoryCode = prod.categoryCode
                    item.price = 0
                    item.qty = 0
                    item.catorder = prod.ordercate
                    item.shopId = shopId
                    item.competitorId = competitorId
                    item.reportDate = Date().toIntShortDate()
                    lstDisplayResults.append(item)
                }
            }
            Insert(lstDisplayResults)
            return lstDisplayResults
            
        }
        return nil
    }
    
    func getValueModelDisplay(_ model: String,lstDisplays: [DisplayModel]?) -> DisplayModel? {
        if let displays = lstDisplays {
            for item in displays {
                if item.model == model {
                    return item
                }
            }
        }
        return nil
    }
    
    func getValueDisplay(_ catCode: String,lstDisplays: [DisplayModel]?) -> DisplayModel? {
        if let displays = lstDisplays {
            for item in displays {
                if item.categoryCode == catCode {
                    return item
                }
            }
        }
        return nil
    }
    
    func getListDisplay(_ competitorId: Int,shopId: Int,empId: Int) -> [DisplayModel]? {
        var displayResults = [DisplayModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "reportDate = \(Date().toIntShortDate())")
        let predicate1 = NSPredicate(format: "competitorid = \(competitorId)")
        let predicate2 = NSPredicate(format: "shopid = '\(shopId)'")
        let predicate3 = NSPredicate(format: "employeeid = '\(empId)'")
        
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3])
        
        if let displays = Display.mr_findAllSorted(by: "catorder",ascending: true, with: predicateCompound, in: context) as? [Display]{
            for entity in displays {
                let model = DisplayModel()
                model.productId = Int(entity.productid)
                model.guideLine = Int(entity.guideline)
                model.employeeId = Int(entity.employeeid)
                if let categorycode = entity.categorycode{
                    model.categoryCode = categorycode
                }
                model.reportDate = Int(entity.reportDate)
                model.createdDate = Int(entity.createdDate)
                model.price = entity.price
                model.qty = Int(entity.qty)
                model.competitorId = Int(entity.competitorid)
                model.indexGroup = Int(entity.indexgroup)
                model.shopId = Int(entity.shopid)
                if let guid = entity.guid{
                    model.guid = guid
                }
                if let m = entity.model{
                    model.model = m
                }
                if let categorygroup = entity.categorygroup{
                    model.categoryGroup = categorygroup
                }
                model.changed = Int(entity.changed)
                model.isChange = Int(entity.ischange)
                displayResults.append(model)
            }
            return displayResults
        }
        return nil
    }
    func GetMaxReportDate(_ shopId: Int) -> Int{
        var displayResults = [DisplayModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "shopid = '\(shopId)'")
        
        if let displays = Display.mr_findAllSorted(by: "reportDate", ascending: true,with: predicate, in: context) as? [Display]{
            if displays.count > 0 {
                return Int(displays[displays.count - 1].reportDate)
            }
        }
        
        return 0
    }
    func getListDisplayModel(_ shopId: Int,empId: Int,competitorId: Int) -> [DisplayModel]? {
        let reportDate = GetMaxReportDate(shopId)
        if reportDate == 0 {
            return nil
        }
        var displayResults = [DisplayModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "reportDate = \(reportDate)")
        let predicate1 = NSPredicate(format: "shopid = '\(shopId)'")
        let predicate2 = NSPredicate(format: "employeeid = '\(empId)'")
        let predicate3 = NSPredicate(format: "competitorid = \(competitorId)")
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3])
        
        if let displays = Display.mr_findAllSorted(by: "categorycode",ascending: true,with: predicateCompound, in: context) as? [Display]{
            for entity in displays {
                let model = DisplayModel()
                model.productId = Int(entity.productid)
                model.guideLine = Int(entity.guideline)
                model.employeeId = Int(entity.employeeid)
                if let categorycode = entity.categorycode{
                    model.categoryCode = categorycode
                }
                model.reportDate = Int(entity.reportDate)
                model.createdDate = Int(entity.createdDate)
                model.price = entity.price
                model.qty = Int(entity.qty)
                model.competitorId = Int(entity.competitorid)
                model.indexGroup = Int(entity.indexgroup)
                model.shopId = Int(entity.shopid)
                if let guid = entity.guid{
                    model.guid = guid
                }
                if let m = entity.model{
                    model.model = m
                }
                if let categorygroup = entity.categorygroup{
                    model.categoryGroup = categorygroup
                }
                model.changed = Int(entity.changed)
                model.isChange = Int(entity.ischange)
                displayResults.append(model)
            }
            return displayResults
        }
        return nil
    }
    func save(_ model: DisplayModel,type: String) {
        if type == "MODEL"{
            Update(model)
        }
        else{
            UpdateCompetitor(model)
        }
    }
    
    func checkDisplay(_ model: DisplayModel) -> Bool{
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "shopid = \(model.shopId)")
        let predicate1 = NSPredicate(format: "model = '\(model.model)'")
        let predicate2 = NSPredicate(format: "reportdate = \(model.reportDate)")
        let predicate3 = NSPredicate(format: "competitorid = \(model.competitorId)")
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3])
        
        if let displays = Display.mr_findAll(with: predicateCompound, in: context) as? [Display]{
            if displays.count > 0 {
                return true
            }
        }
        return false
    }
    
    func Update(_ model: DisplayModel) {
        MagicalRecord.save({ (context) in
            let predicate = NSPredicate(format: "shopid = \(model.shopId)")
            let predicate1 = NSPredicate(format: "model = '\(model.model)'")
            let predicate2 = NSPredicate(format: "reportDate = \(model.reportDate)")
            let predicate3 = NSPredicate(format: "competitorid = \(model.competitorId)")
            var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3])
            if let entity = Display.mr_findFirst(with: predicateCompound,in: context) {
                entity.qty = Int32(model.qty)
            }
        })
    }
    func UpdateCompetitor(_ model: DisplayModel) {
        MagicalRecord.save({ (context) in
            let predicate = NSPredicate(format: "shopid = \(model.shopId)")
            let predicate1 = NSPredicate(format: "categorycode = '\(model.categoryCode)'")
            let predicate2 = NSPredicate(format: "reportDate = \(model.reportDate)")
            let predicate3 = NSPredicate(format: "competitorid = \(model.competitorId)")
            var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3])
            if let entity = Display.mr_findFirst(with: predicateCompound,in: context) {
                entity.qty = Int32(model.qty)
            }
        })
    }
    func Insert(_ list: [DisplayModel]?) {
        MagicalRecord.save({ (context) in
            for model in list!{
                if let entity = Display.mr_createEntity(in: context){
                    entity.shopid = Int32(model.shopId)
                    entity.productid = Int32(model.productId)
                    entity.guideline = Int32(model.guideLine)
                    entity.employeeid = Int32(model.employeeId)
                    entity.createdDate = Int32(model.createdDate)
                    entity.reportDate = Int32(model.reportDate)
                    entity.categorycode = model.categoryCode
                    entity.catorder = Int32(model.catorder)
                    entity.qty = Int32(model.qty)
                    entity.price = model.price
                    entity.competitorid = Int32(model.competitorId)
                    entity.model = model.model
                    entity.categorygroup = model.categoryGroup
                    entity.ischange = 0
                    entity.changed = 0
                }
            }
        })
    }
}
