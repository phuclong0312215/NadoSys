//
//  DataOfflineController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/8/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import MagicalRecord
import Alamofire
import  SwiftyJSON
import ObjectMapper
import Toast_Swift
public class DataOfflineController: IDataOffline{
  
    var _http: Http?
    
    init() {
        _http = Http()
    }
    
    func GetCategory() -> [ProductModel]? {
        var productResults = [ProductModel]()
        let context = NSManagedObjectContext.mr_()
        let fetchRequest =  Product.mr_requestAllSorted(by: "catorder", ascending: true, in: context)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = ["categorycode"]
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let results = try context.fetch(fetchRequest)
            var i = 1
            for r in results {
                let model = ProductModel()
                let catcode = (r as AnyObject).value(forKey: "categorycode") as! String
                // let catename = (r as AnyObject).value(forKey: "categoryname") as! String
                if catcode != ""{
                    model.categoryCode = catcode
                    model.ordercate = i
                    i = i + 1
                    //model.categoryName = catename
                    productResults.append(model)
                }
            }
            return productResults
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        return nil
    }
    func DownloadData(completionHandler: @escaping (Bool?) -> ()) {
        var _login = Defaults.getUser(key: "LOGIN")
        let paramaters: Parameters = ["EmployeeId": _login?.employeeId]
      //  SVProgressHUD.showInfo(withStatus: "Đang cập nhật dữ lieu, vui lòng chờ…")
        _http?.performRequest(.get, requestURL: URLs.URL_DOWNLOAD_DATA, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                let kpis = swiftJSON["function"].object
                let products = swiftJSON["product"].object
                let displayguides = swiftJSON["display"].object
                let objectDatas = swiftJSON["objectData"].object
                let shops = swiftJSON["shop"].object
                let supplier = swiftJSON["supplier"].object
                let sell7day = swiftJSON["sell7day"].object
                let arrKpi = Mapper<KPIModel>().mapArray(JSONObject: kpis)
                self.InsertKPIs(arrKpi!)
                let arrProduct = Mapper<ProductModel>().mapArray(JSONObject: products)
                self.InsertProducts(arrProduct!)
                let arrDisplayGuide = Mapper<DisplayGuideModel>().mapArray(JSONObject: displayguides)
                self.InsertDisplayGuides(arrDisplayGuide!)
                let arrObjectDatas = Mapper<ObjectDataModel>().mapArray(JSONObject: objectDatas)
                self.InsertObjectDatas(arrObjectDatas!)
                let arrShops = Mapper<ShopModel>().mapArray(JSONObject: shops)
                self.InsertShops(arrShops!,empId: (_login?.employeeId)!)
                let arrSuppliers = Mapper<SupplierModel>().mapArray(JSONObject: supplier)
                self.InsertSuppliers(arrSuppliers!)
                let arrSell7days = Mapper<SellOutModel>().mapArray(JSONObject: sell7day)
                self.InsertSellOut(arrSell7days!)
                //SVProgressHUD.dismiss()
                completionHandler(true)
            }
            completionHandler(false)
        }
        
        
    }
    func DownloadDataRegion(completionHandler: @escaping (Bool?) -> ()) {
        let _login = Defaults.getUser(key: "LOGIN")
        let paramaters: Parameters = ["EmployeeId": _login?.employeeId]
        _http?.performRequest(.get, requestURL: URLs.URL_DOWNLOAD_REGION, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                let region = swiftJSON["region"].object
                let province = swiftJSON["province"].object
                let district = swiftJSON["district"].object
                let ward = swiftJSON["ward"].object
                let arrRegion = Mapper<RegionModel>().mapArray(JSONObject: region)
                self.InsertRegions(arrRegion!)
                let arrProvince = Mapper<ProvinceModel>().mapArray(JSONObject: province)
                self.InsertProvinces(arrProvince!)
                let arrDistrict = Mapper<DistrictModel>().mapArray(JSONObject: district)
                self.InsertDistricts(arrDistrict!)
                let arrWards = Mapper<WardModel>().mapArray(JSONObject: ward)
                self.InsertWards(arrWards!)
                completionHandler(true)
            }
            completionHandler(false)
        }
        
        
    }
    func GetAllData() {
        var _login = Defaults.getUser(key: "LOGIN")
        let paramaters: Parameters = ["EmployeeId": _login?.employeeId]
        _http?.performRequest(.get, requestURL: URLs.URL_KPI, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON).object
                let kpis = Mapper<KPIModel>().mapArray(JSONObject: swiftJSON)
                self.InsertKPIs(kpis!)
            }
        }
        _http?.performRequest(.get, requestURL: URLs.URL_PRODUCT, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                let products = Mapper<ProductModel>().mapArray(JSONObject: swiftJSON["product"].object)
                self.InsertProducts(products!)
            }
        }
        _http?.performRequest(.get, requestURL: URLs.URL_DISPLAYGUIDE, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                let displayguides = Mapper<DisplayGuideModel>().mapArray(JSONObject: swiftJSON["disguide"].object)
                self.InsertDisplayGuides(displayguides!)
            }
        }
        _http?.performRequest(.get, requestURL: URLs.URL_OBJECTDATA, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON).object
                let objects = Mapper<ObjectDataModel>().mapArray(JSONObject: swiftJSON)
                self.InsertObjectDatas(objects!)
            }
        }
        _http?.performRequest(.get, requestURL: URLs.URL_SHOP, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON).object
                let shops = Mapper<ShopModel>().mapArray(JSONObject: swiftJSON)
                self.InsertShops(shops!,empId: (_login?.employeeId)!)
            }
        }
    }
    
    func InsertSellOut(_ list: [SellOutModel]) {
        MagicalRecord.save({ (context) in
            for model in list {
                if !self.IsSellOutExists(model.shopId, empId: model.employeeId, saleDate: model.saleDate, objId: model.objId, productId: model.productId){
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
            }
        })
    }
    
    func IsSellOutExists(_ shopId: Int,empId: Int,saleDate: String,objId: Int,productId: Int) -> Bool {
        var results = [SellOutModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "saleDate = '\(saleDate)'")
        let predicate1 = NSPredicate(format: "shopId = '\(shopId)'")
        let predicate2 = NSPredicate(format: "employeeId = '\(empId)'")
        let predicate3 = NSPredicate(format: "objId = '\(objId)'")
        let predicate4 = NSPredicate(format: "productId = '\(productId)'")
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1,predicate2,predicate3,predicate4])
        
        if let sellouts = SellOut.mr_findFirst(with: predicateCompound, in: context) as? SellOut{
            return true
        }
        return false
    }
    
    func InsertWards(_ list: [WardModel]) {
        MagicalRecord.save({ (context) in
            // Shops.mr_truncateAll(in: context)
            for model in list {
                if let entity = Ward.mr_createEntity(in: context){
                    entity.districtId = Int32(model.districtId)
                    entity.provinceId = Int32(model.provinceId)
                    entity.wardId = Int32(model.wardId)
                    entity.wardName = model.wardName
                    entity.wardName_Vi_vn = model.wardName_Vi_vn
                }
                
            }
        })
    }
    
    
    func InsertDistricts(_ list: [DistrictModel]) {
        MagicalRecord.save({ (context) in
            // Shops.mr_truncateAll(in: context)
            for model in list {
                if let entity = District.mr_createEntity(in: context){
                    entity.districtId = Int32(model.districtId)
                    entity.provinceId = Int32(model.provinceId)
                    entity.districtName = model.districtName
                    entity.districtName_Vi_vn = model.districtName_Vi_vn
                }
                
            }
        })
    }
    
    func InsertProvinces(_ list: [ProvinceModel]) {
        MagicalRecord.save({ (context) in
            // Shops.mr_truncateAll(in: context)
            for model in list {
                if let entity = Province.mr_createEntity(in: context){
                    entity.provinceId = Int32(model.provinceId)
                    entity.regionId = Int32(model.regionId)
                    entity.regionName = model.regionName
                    entity.provinceName = model.provinceName
                    entity.provinceName_Vi_vn = model.provinceName_Vi_vn
                }
                
            }
        })
    }
    
    func InsertRegions(_ list: [RegionModel]) {
        MagicalRecord.save({ (context) in
            // Shops.mr_truncateAll(in: context)
            for model in list {
                if let entity = Region.mr_createEntity(in: context){
                    entity.id = Int32(model.id)
                    entity.area = model.area
                    entity.regionName = model.regionName
                    entity.parentId = Int32(model.parentId)
                    entity.isActive = model.isActive
                    entity.orderby = Int32(model.orderby)
                }
                
            }
        })
    }
    
    func InsertShops(_ list: [ShopModel],empId: Int) {
        MagicalRecord.save({ (context) in
           // Shops.mr_truncateAll(in: context)
            for model in list {
                if let entity = Shops.mr_createEntity(in: context){
                    entity.id = Int32(model.id)
                    entity.address = model.address
                    entity.area = model.area
                    entity.city = model.city
                    entity.district = model.district
                    entity.region = model.region
                    entity.shopid = Int32(model.shopId)
                    entity.empid = Int32(empId)
                    entity.shopname = model.shopName
                    entity.shopcode = model.shopCode
                }
                
            }
        })
    }
    
    func InsertSuppliers(_ list: [SupplierModel]) {
        MagicalRecord.save({ (context) in
            Supplier.mr_truncateAll(in: context)
            for model in list {
                if let entity = Supplier.mr_createEntity(in: context){
                    entity.supplierId = Int32(model.supplierId)
                    entity.address = model.address
                    entity.area = model.area
                    entity.districtId = Int32(model.districtId)
                    entity.wardId = Int32(model.wardId)
                    entity.regionId = Int32(model.wardId)
                    entity.provinceId = Int32(model.provinceId)
                    entity.createdDate = model.createdDate
                    entity.supplierCode = model.supplierCode
                    entity.supplierName = model.supplierName
                }
                
            }
        })
    }
    
    
    func InsertProducts(_ list: [ProductModel]) {
        MagicalRecord.save({ (context) in
            Product.mr_truncateAll(in: context)
            for model in list {
                if let entity = Product.mr_createEntity(in: context){
                    entity.productid = Int32(model.productId)
                    entity.sapcode = model.sapcode
                    entity.model = model.model
                    entity.capacity = model.capacity
                    entity.barcode = model.barcode
                    entity.subcat1 = model.subCat1
                    entity.subcat2 = model.subCat2
                    entity.subcat3 = model.subCat3
                    entity.subcat4 = model.subCat4
                    entity.status = Int32(model.status)
                    entity.isdeleted = Int32(model.deleted)
                    entity.isnew = Int32(model.isNew)
                    if model.categoryCode == ""{
                        entity.categorycode = "OTHER"
                        entity.categoryname = "OTHER"
                    }
                    else{
                        entity.categorycode = model.categoryCode
                        entity.categoryname = model.categoryName
                    }
                    if model.categoryCode == "REF"{
                        entity.catorder = 1
                    }
                    else if model.categoryCode == "WM"{
                        entity.catorder = 2
                    }
                    else if model.categoryCode == "AC"{
                        entity.catorder = 3
                    }
                    else if model.categoryCode == "OTHER"{
                        entity.catorder = 4
                    }
                    else{
                        entity.catorder = 5
                    }
                    entity.capacity = model.capacity
                    entity.keymodels = model.keymodels
                    entity.price = model.price
                }
                
            }
        })
    }
    
    func InsertKPIs(_ list: [KPIModel]) {
        MagicalRecord.save({ (context) in
            KPI.mr_truncateAll(in: context)
            for model in list {
                if let entity = KPI.mr_createEntity(in: context){
                    entity.id = Int32(model.id)
                    entity.functionname = model.functionName
                    entity.functionname_vi_vn = model.functionName_vi_vn
                    entity.functionicon = model.functionIcon
                    entity.acitve = Int32(model.active)
                    entity.orderby = Int32(model.orderby)
                    entity.ischeckin = Int32(model.isCheckIn)
                    entity.ischeckout = Int32(model.isCheckOut)
                    entity.issaleout = Int32(model.isSaleOut)
                    entity.issalethrought = Int32(model.isSaleThrough)
                    entity.isdisplay = Int32(model.isDisplay)
                    entity.isdisplayimage = Int32(model.isDisplayImage)
                    entity.issalein = Int32(model.isSaleIn)
                    entity.requirecheckin = Int32(model.requieCheckIn)
                }
                
            }
        })
    }
    
    func InsertObjectDatas(_ list: [ObjectDataModel]) {
        MagicalRecord.save({ (context) in
            ObjectData.mr_truncateAll(in: context)
            for model in list {
                if let entity = ObjectData.mr_createEntity(in: context){
                    entity.objectid = Int32(model.objectId)
                    entity.objecttype = model.objectType
                    entity.objectname = model.objectName
                    entity.sortby = Int32(model.sortby)
                    entity.isscan = Int32(model.isScaner)
                }
                
            }
        })
    }
    
    func InsertDisplayGuides(_ list: [DisplayGuideModel]) {
        MagicalRecord.save({ (context) in
            DisplayGuide.mr_truncateAll(in: context)
            for model in list {
                if let entity = DisplayGuide.mr_createEntity(in: context){
                    entity.id = Int32(model.id)
                    entity.shopid = Int32(model.shopId)
                    entity.productid = Int32(model.productId)
                    entity.guideline = Int32(model.guideLine)
                    entity.photo = model.photo
                }
                
            }
        })
    }
    
    func GetListSuppliers() -> [SupplierModel]? {
        var results = [SupplierModel]()
        let context = NSManagedObjectContext.mr_()
        if let objs = Supplier.mr_findAll(in: context) as? [Supplier]{
            for entity in objs {
                let model = SupplierModel()
                model.supplierId = Int(entity.supplierId)
                if let address = entity.address{
                    model.address = address
                }
                if let area = entity.area{
                    model.area = area
                }
                if let supplierCode = entity.supplierCode{
                    model.supplierCode = supplierCode
                }
                model.provinceId = Int(entity.provinceId)
                model.districtId = Int(entity.districtId)
                model.regionId = Int(entity.regionId)
                model.wardId = Int(entity.wardId)
                if let supplierName = entity.supplierName{
                    model.supplierName = supplierName
                }
                if let createdDate = entity.createdDate{
                    model.createdDate = createdDate
                }
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetListShops(_ empId: Int) -> [ShopModel]? {
        var results = [ShopModel]()
        let predicate = NSPredicate(format: "empid = '\(empId)'")
        let context = NSManagedObjectContext.mr_()
        if let objs = Shops.mr_findAllSorted(by: "shopid", ascending: true,with: predicate, in: context) as? [Shops]{
            for entity in objs {
                let model = ShopModel()
                model.id = Int(entity.id)
                if let address = entity.address{
                    model.address = address
                }
                if let area = entity.area{
                    model.area = area
                }
                if let city = entity.city{
                    model.city = city
                }
                if let district = entity.district{
                    model.district = district
                }
                if let region = entity.region{
                    model.region = region
                }
                model.shopId = Int(entity.shopid)
                model.employeeId = Int(entity.empid)
                if let shopname = entity.shopname{
                    model.shopName = shopname
                }
                if let shopcode = entity.shopcode{
                    model.shopCode = shopcode
                }
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetListKPIs() -> [KPIModel]? {
        var results = [KPIModel]()
        let context = NSManagedObjectContext.mr_()
        if let objs = KPI.mr_findAllSorted(by: "orderby", ascending: true, in: context) as? [KPI]{
            for entity in objs {
                let model = KPIModel()
                model.id = Int(entity.id)
                if let functionName = entity.functionname{
                    model.functionName = functionName
                }
                if let functionName_vi_vn = entity.functionname_vi_vn{
                    model.functionName_vi_vn = functionName_vi_vn
                }
                if let functionIcon = entity.functionicon{
                    model.functionIcon = functionIcon
                }
                model.orderby = Int(entity.orderby)
                model.isCheckIn = Int(entity.ischeckin)
                model.isCheckOut = Int(entity.ischeckout)
                model.isSaleOut = Int(entity.issaleout)
                model.isSaleThrough = Int(entity.issalethrought)
                model.isDisplay = Int(entity.isdisplay)
                model.isDisplayImage = Int(entity.isdisplayimage)
                model.isSaleIn = Int(entity.issalein)
                model.requieCheckIn = Int(entity.requirecheckin)
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetListRegions() -> [RegionModel]? {
        var results = [RegionModel]()
        let context = NSManagedObjectContext.mr_()
        
        if let objs = Region.mr_findAllSorted(by: "orderby", ascending: true, in: context) as? [Region]{
            for entity in objs {
                let model = RegionModel()
                model.id = Int(entity.id)
                model.orderby = Int(entity.orderby)
                model.parentId = Int(entity.parentId)
                if let area = entity.area{
                    model.area = area
                }
                if let regionName = entity.regionName{
                    model.regionName = regionName
                }
                model.isActive = entity.isActive
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetListProvinces() -> [ProvinceModel]? {
        var results = [ProvinceModel]()
        let context = NSManagedObjectContext.mr_()
        
        if let objs = Province.mr_findAll(in: context) as? [Province]{
            for entity in objs {
                let model = ProvinceModel()
                model.provinceId = Int(entity.provinceId)
                model.regionId = Int(entity.regionId)
                if let regionName = entity.regionName{
                    model.regionName = regionName
                }
                if let provinceName = entity.provinceName{
                    model.provinceName = provinceName
                }
                if let provinceName_Vi_vn = entity.provinceName_Vi_vn{
                    model.provinceName_Vi_vn = provinceName_Vi_vn
                }
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetListDistrict(_ provinceId: Int) -> [DistrictModel]? {
        var results = [DistrictModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "provinceId = '\(provinceId)'")
        if let objs = District.mr_findAll(with: predicate, in: context) as? [District]{
            for entity in objs {
                let model = DistrictModel()
                model.provinceId = Int(entity.provinceId)
                model.districtId = Int(entity.districtId)
                if let districtName = entity.districtName{
                    model.districtName = districtName
                }
                if let districtName_Vi_vn = entity.districtName_Vi_vn{
                    model.districtName_Vi_vn = districtName_Vi_vn
                }
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetListWard(_ districtId: Int) -> [WardModel]? {
        var results = [WardModel]()
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "districtId = '\(districtId)'")
        if let objs = Ward.mr_findAll(with: predicate, in: context) as? [Ward]{
            for entity in objs {
                let model = WardModel()
                model.provinceId = Int(entity.provinceId)
                model.districtId = Int(entity.districtId)
                model.wardId = Int(entity.wardId)
                if let wardName = entity.wardName{
                    model.wardName = wardName
                }
                if let wardName_Vi_vn = entity.wardName_Vi_vn{
                    model.wardName_Vi_vn = wardName_Vi_vn
                }
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetListObjectDatas(_ objectType: String) -> [ObjectDataModel]? {
        var results = [ObjectDataModel]()
        let predicate = NSPredicate(format: "objecttype = '\(objectType)'")
        let context = NSManagedObjectContext.mr_()
        
        if let objs = ObjectData.mr_findAllSorted(by: "sortby", ascending: true,with: predicate, in: context) as? [ObjectData]{
            for entity in objs {
                let model = ObjectDataModel()
                model.objectId = Int(entity.objectid)
                model.sortby = Int(entity.sortby)
                if let objectname = entity.objectname{
                    model.objectName = objectname
                }
                if let objecttype = entity.objecttype{
                    model.objectType = objecttype
                }
                model.isScaner = Int(entity.isscan)
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func ByObjectName(_ objectType: String,objectName: String) -> ObjectDataModel? {
        var results = [ObjectDataModel]()
        let predicate = NSPredicate(format: "objecttype = '\(objectType)'")
        let predicate1 = NSPredicate(format: "objectname = '\(objectName)'")
        let context = NSManagedObjectContext.mr_()
        var predicateCompound = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate,predicate1])
        if let entity = ObjectData.mr_findFirst(with: predicateCompound, in: context){
            let model = ObjectDataModel()
            model.objectId = Int(entity.objectid)
            model.sortby = Int(entity.sortby)
            if let objectname = entity.objectname{
                model.objectName = objectname
            }
            if let objecttype = entity.objecttype{
                model.objectType = objecttype
            }
            return model
        }
        return nil
    }
    
    func GetListDisplayGuides(_ shopId: Int) -> [DisplayGuideModel]? {
        var results = [DisplayGuideModel]()
        let predicate = NSPredicate(format: "shopid = \(shopId)")
        let context = NSManagedObjectContext.mr_()
        
        if let objs = DisplayGuide.mr_findAll(with: predicate, in: context) as? [DisplayGuide]{
            for entity in objs {
                let model = DisplayGuideModel()
                model.productId = Int(entity.productid)
                model.guideLine = Int(entity.guideline)
                model.shopId = Int(entity.shopid)
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetListProductss() -> [ProductModel]? {
        var results = [ProductModel]()
        let context = NSManagedObjectContext.mr_()
        if let objs = Product.mr_findAll( in: context) as? [Product]{
            for entity in objs {
                let model = ProductModel()
                model.productId = Int(entity.productid)
                if let sapcode = entity.sapcode{
                    model.sapcode = sapcode
                }
                if let categoryname = entity.categoryname{
                    model.categoryName = categoryname
                }
                if let categorycode = entity.categorycode{
                    model.categoryCode = categorycode
                }
                model.price = Double(entity.price)
                if let subcat1 = entity.subcat1{
                    model.subCat1 = subcat1
                }
                if let subcat2 = entity.subcat2{
                    model.subCat2 = subcat2
                }
                if let subcat3 = entity.subcat3{
                    model.subCat3 = subcat3
                }
                if let subcat4 = entity.subcat4{
                    model.subCat4 = subcat4
                }
                if let m = entity.model{
                    model.model = m
                }
                if let keymodels = entity.keymodels{
                    model.keymodels = keymodels
                }
                if let barcode = entity.barcode{
                    model.barcode = barcode
                }
                if let createdate = entity.createdate{
                    model.createdDate = createdate
                }
                model.isNew = Int(entity.isnew)
                model.deleted = Int(entity.isdeleted)
                results.append(model)
            }
            return results
        }
        return nil
    }
    
    func GetProductByBarCode(_ barcode: String) -> ProductModel? {
        let context = NSManagedObjectContext.mr_()
        let predicate = NSPredicate(format: "barcode = '\(barcode)'")
        if let entity = Product.mr_findFirst(with: predicate,in: context) as? Product{
            let model = ProductModel()
            model.productId = Int(entity.productid)
            if let sapcode = entity.sapcode{
                model.sapcode = sapcode
            }
            if let categoryname = entity.categoryname{
                model.categoryName = categoryname
            }
            if let categorycode = entity.categorycode{
                model.categoryCode = categorycode
            }
            model.price = Double(entity.price)
            if let subcat1 = entity.subcat1{
                model.subCat1 = subcat1
            }
            if let subcat2 = entity.subcat2{
                model.subCat2 = subcat2
            }
            if let subcat3 = entity.subcat3{
                model.subCat3 = subcat3
            }
            if let subcat4 = entity.subcat4{
                model.subCat4 = subcat4
            }
            if let m = entity.model{
                model.model = m
            }
            if let keymodels = entity.keymodels{
                model.keymodels = keymodels
            }
            if let barcode = entity.barcode{
                model.barcode = barcode
            }
            if let createdate = entity.createdate{
                model.createdDate = createdate
            }
            model.isNew = Int(entity.isnew)
            model.deleted = Int(entity.isdeleted)
            return model
        }
        return nil
    }
    
    func GetListProductByGuideLine(_ shopId: Int) -> [ProductModel]? {
        let products = GetListDisplayGuides(shopId)
        var results = [ProductModel]()
        let context = NSManagedObjectContext.mr_()
        if let objs = Product.mr_findAllSorted(by: "catorder",ascending: true,in: context) as? [Product]{
            for entity in objs {
                let data = products!.filter{$0.productId == entity.productid}.first
                if data != nil{
                    let model = ProductModel()
                    model.productId = Int(entity.productid)
                    if let sapcode = entity.sapcode{
                        model.sapcode = sapcode
                    }
                    if let categoryname = entity.categoryname{
                        model.categoryName = categoryname
                    }
                    if let categorycode = entity.categorycode{
                        model.categoryCode = categorycode
                    }
                    model.price = Double(entity.price)
                    if let subcat1 = entity.subcat1{
                        model.subCat1 = subcat1
                    }
                    if let subcat2 = entity.subcat2{
                        model.subCat2 = subcat2
                    }
                    if let subcat3 = entity.subcat3{
                        model.subCat3 = subcat3
                    }
                    if let subcat4 = entity.subcat4{
                        model.subCat4 = subcat4
                    }
                    if let m = entity.model{
                        model.model = m
                    }
                    if let keymodels = entity.keymodels{
                        model.keymodels = keymodels
                    }
                    if let barcode = entity.barcode{
                        model.barcode = barcode
                    }
                    model.guideLine = (data?.guideLine)!
                    if let createdate = entity.createdate{
                        model.createdDate = createdate
                    }
                    model.isNew = Int(entity.isnew)
                    model.deleted = Int(entity.isdeleted)
                    results.append(model)
                }
            }
            return results
        }
        return nil
    }
    
    
    
}
