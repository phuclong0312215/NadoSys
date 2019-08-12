//
//  IDataOnline.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/16/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
protocol IDataOnline {
     func GetReportEmployeeAvg(_ id: Int,shopId: Int, completionHandler: @escaping ([EmployeeAvgModel]?, String?) -> ()) 
      func GetReportEmployeeAttadance(_ id: Int,shopId: Int,fromDate: String,toDate: String, completionHandler: @escaping ([EmployeeAttModel]?, String?) -> ()) 
      func GetShopKeyAccount(_ id: Int,channelId: Int,type: String,area: String,regionId: Int, completionHandler: @escaping ([ShopModel]?, String?) -> ()) 
      func GetReportMarketShop(_ id: Int, completionHandler: @escaping ([ReportMarketShopModel]?,[ReportMarketShopModel]?, String?) -> ())
      func GetPosmList(_ id: Int,type: String,shopId: Int,reportDate: String,url: String, completionHandler: @escaping ([POSMModel]?, String?) -> ()) 
      func GetPosmByEmployeeId(_ id: Int, completionHandler: @escaping ([POSMModel]?, String?) -> ())
      func GetShopById(_ id: Int, completionHandler: @escaping (ShopModel?, String?) -> ()) 
      func UploadDisplay(_ url: String, data: [Data],completionHandler: @escaping (String?, String?) -> ())
      func SaveInfo(_ data: Data,url: String, completionHandler: @escaping (AnyObject?, String?) -> ())
}
