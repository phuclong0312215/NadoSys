//
//  LoginController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/8/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
class LoginController: ILogin{
    func Login(_ data: Data, url: String, completionHandler: @escaping (LoginModel?, String?) -> ()) {
        _http?.requestJSONLogin(url, jsonData: data, completionHandler: { (responseJSON) in
            if responseJSON != nil{
                
                let swiftJSON = JSON(responseJSON)
                let login = Mapper<LoginModel>().map(JSONString: swiftJSON.rawString()!)
                completionHandler(login, nil)
            }
            else{
                completionHandler(nil, "save info failure")
            }
        })
    }
    
    func GetById(_ id: Int, completionHandler: @escaping (LoginModel?, String?) -> ()) {
        let paramaters: Parameters = [
            "id": id
        ]
        _http?.performRequest(.get, requestURL: URLs.URL_CV, params: paramaters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                print(swiftJSON)
                let login = Mapper<LoginModel>().map(JSONString: swiftJSON.rawString()!)
                completionHandler(login, nil)
            }
            else{
                completionHandler(nil,"login error.")
            }
        }
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
    
    var _http: Http?
    
    init() {
        _http = Http()
    }
    
    
}



