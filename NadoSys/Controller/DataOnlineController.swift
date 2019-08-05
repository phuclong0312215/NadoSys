//
//  DataOnlineController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/16/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//


import Foundation
import MagicalRecord
import Alamofire
import  SwiftyJSON
import ObjectMapper
public class DataOnlineController: IDataOnline{
    
    var _http: Http?
    
    init() {
        _http = Http()
    }
    
    func GetShopKeyAccount(_ id: Int,channelId: Int,type: String,area: String,regionId: Int, completionHandler: @escaping ([ShopModel]?, String?) -> ()) {
        var paramaters: Parameters = [
            "RowPerPage": 100,
            "PageNumber": 1,
            "UserId": id,
            "channelId": 3,
            "Area": area,
            "regionId": regionId
        ]
        if type == "Key Account"{
            paramaters.removeValue(forKey: "Area")
            paramaters.removeValue(forKey: "regionId")
            paramaters.updateValue(channelId, forKey: "channelId")
        }
        else if type == "Key Shop"{
             paramaters.removeValue(forKey: "regionId")
        }
        else if type == "Region"{
            paramaters.removeValue(forKey: "Area")
            paramaters.updateValue("1058 1084", forKey: "channelId")
        }
        else if type == "Area"{
            paramaters.removeValue(forKey: "regionId")
            paramaters.updateValue("1058 1084", forKey: "channelId")
        }
        _http?.performRequest(.get, requestURL: URLs.URL_ALLSHOPS, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                let shops = swiftJSON.object
                let arrShops = Mapper<ShopModel>().mapArray(JSONObject: shops)
                completionHandler(arrShops, nil)
            }
            else{
                completionHandler(nil,"get shop error.")
            }
        }
    }
    
    func GetReportMarketShop(_ id: Int, completionHandler: @escaping ([ReportMarketShopModel]?,[ReportMarketShopModel]?, String?) -> ()) {
        let paramaters: Parameters = [
            "userId": id
        ]
        _http?.performRequest(.get, requestURL: URLs.URL_REPORT_MARKETSHOP, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                let mts = swiftJSON["mt"].object
                let gts = swiftJSON["gt"].object
                let arrMts = Mapper<ReportMarketShopModel>().mapArray(JSONObject: mts)
                let arrGts = Mapper<ReportMarketShopModel>().mapArray(JSONObject: gts)
                completionHandler(arrMts,arrGts, nil)
            }
            else{
                completionHandler(nil,nil,"get shop error.")
            }
        }
    }
    
    func GetPosmByEmployeeId(_ id: Int, completionHandler: @escaping ([POSMModel]?, String?) -> ()) {
        let paramaters: Parameters = [
            "EmployeeId": id
        ]
        _http?.performRequest(.get, requestURL: URLs.URL_POSM_GETDATA, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                let arrPosms = swiftJSON.object
                let posms = Mapper<POSMModel>().mapArray(JSONObject: arrPosms)
                completionHandler(posms, nil)
            }
            else{
                completionHandler(nil,"get shop error.")
            }
        }
    }
    
    func GetPosmList(_ id: Int,type: String,shopId: Int,reportDate: String,url: String, completionHandler: @escaping ([POSMModel]?, String?) -> ()) {
        var paramaters: Parameters = [:]
        if type == "STOCK"{
            paramaters = [
                "EmployeeId": id,
                "UserId": id,
                "type": "in",
                "shopId": shopId,
                "date": reportDate,
            ]
        }
        else{
             paramaters = [
                "EmployeeId": id,
                "shopId": shopId,
                "date": reportDate,
                ]
        }
        
        _http?.performRequest(.get, requestURL: url, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                let arrPosms = swiftJSON.object
                let posms = Mapper<POSMModel>().mapArray(JSONObject: arrPosms)
                completionHandler(posms, nil)
            }
            else{
                completionHandler(nil,"get shop error.")
            }
        }
    }
    
    
    func GetShopById(_ id: Int, completionHandler: @escaping (ShopModel?, String?) -> ()) {
        let paramaters: Parameters = [
            "ShopId": id
        ]
        _http?.performRequest(.get, requestURL: URLs.URL_SHOP_PROFILE, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                print(swiftJSON)
                let shop = Mapper<ShopModel>().map(JSONString: swiftJSON.rawString()!)
                completionHandler(shop, nil)
            }
            else{
                completionHandler(nil,"get shop error.")
            }
        }
    }
    
    func UploadDisplay(_ url: String, data: [Data],completionHandler: @escaping (String?, String?) -> ()){
        _http?.uploadFiles(url, arrData: data, fileName: "", mimeType: "", completionHandler: { (data, error) in
            if data != nil{
                completionHandler(data, nil)
            }
            else{
                completionHandler(nil, "Error upload data")
            }
        })
    }
    func SaveInfo(_ data: Data,url: String, completionHandler: @escaping (AnyObject?, String?) -> ()) {
        _http?.requestJSON(url, jsonData: data, completionHandler: { (responseJSON) in
            if responseJSON != nil{
                completionHandler(responseJSON, nil)
            }
            else{
                completionHandler(nil, "save info failure")
            }
        })
    }
    
}
