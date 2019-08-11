//
//  IDataOffline.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/8/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
protocol IDataOffline {
    func InsertShops(_ list: [ShopModel],empId: Int)
    func InsertProducts(_ list: [ProductModel])
    func InsertSuppliers(_ list: [SupplierModel])
    func InsertKPIs(_ list: [KPIModel])
    func InsertObjectDatas(_ list: [ObjectDataModel])
    func InsertDisplayGuides(_ list: [DisplayGuideModel])
    func GetListSuppliers() -> [SupplierModel]? 
    func GetListShops(_ empId: Int) -> [ShopModel]?
    func GetListKPIs() -> [KPIModel]?
    func GetListRegions() -> [RegionModel]?
    func GetListWard(_ districtId: Int) -> [WardModel]?
    func GetListDistrict(_ provinceId: Int) -> [DistrictModel]?
    func GetListProvinces() -> [ProvinceModel]?
    func GetListProductss() -> [ProductModel]?
    func GetAllData()
    func DownloadData(completionHandler: @escaping (Bool?) -> ())
    func DownloadDataRegion(completionHandler: @escaping (Bool?) -> ())
    func GetCategory() -> [ProductModel]?
    func GetListObjectDatas(_ objectType: String) -> [ObjectDataModel]?
    func GetListProductByGuideLine(_ shopId: Int) -> [ProductModel]?
    func ByObjectName(_ objectType: String,objectName: String) -> ObjectDataModel?
    func GetProductByBarCode(_ barcode: String) -> ProductModel?
}
