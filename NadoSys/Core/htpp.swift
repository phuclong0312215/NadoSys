//
//  htpp.swift
//  Panasonic
//
//  Created by PHUCLONG on 8/4/16.
//  Copyright © 2016 PHUCLONG. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
extension String {
    var URLEncoded:String {
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharset = CharacterSet(charactersIn: unreservedChars)
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: unreservedCharset)
        return encodedString ?? self
    }
}
class Http {
    var acessToken = ""
    var employeeId: Int = 0
    var passWord = ""
    
    init() {
       
    }
    init (accesstoken: String,employeeId: Int,password: String){
        self.acessToken = accesstoken
        self.employeeId = employeeId
        self.passWord = password
        
    }
    func requestTimeServer(_ parameters: Parameters,URL: String,completionHandler: @escaping (Bool?, String?) -> ()){
        performRequest(.get, requestURL: URL, params: parameters as [String : AnyObject]) { (responseJSON) in
            if(responseJSON != nil){
                let swiftJSON = JSON(responseJSON)
                let dateFormatter = Function.getDateFormater()
                let timeClient = dateFormatter.date(from: Date().toLongTimeString())!
                let timeServer = dateFormatter.date(from: swiftJSON.stringValue)!
                let flag = Function.checkTime(timeClient: timeClient, timeServer: timeServer)
                completionHandler(flag,nil)
                
            }
            else{
                completionHandler(false,"Không lấy được thời gian server.")
            }

        }
    }
    func uploadFiles(_ URL_UploadImage: String,arrData: [Data],fileName: String,mimeType: String,completionHandler: @escaping (String?, String?) -> ()){
        requestSaveFile(URL_UploadImage, arrData: arrData,fileName: fileName,mimeType: mimeType, completionHandler: completionHandler)
    }
    func requestSaveFile(_ URL_UploadImage: String,arrData: [Data],fileName: String,mimeType: String,completionHandler: @escaping (String?, String?) -> ()){
        self.acessToken = Defaults.getUser(key: "LOGIN")!.access_token
        self.employeeId = Defaults.getUser(key: "LOGIN")!.employeeId
        self.passWord = Defaults.getUser(key: "LOGIN")!.password
        let credentialData = "\(employeeId):\(passWord)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)",
            "ACCESS_TOKEN": acessToken]
        Alamofire.upload(multipartFormData: { multipartFormData in
            
                for i in 0 ..< arrData.count {
                //let imgData = UIImageJPEGRepresentation(arrImage[i], 1)!
                //multipartFormData.append(arrData[i], withName: "fileset",fileName: fileName, mimeType: "image/jpg")
                    if i == 0 {
                         multipartFormData.append(arrData[i], withName: "fileset",fileName:"image_avatar.jpg", mimeType: "image/jpg")
                    }
                    else{
                       multipartFormData.append(arrData[i], withName: "fileset",fileName: "info.json", mimeType: "application/json")
                    }
                
            }
        },
                         to:URL_UploadImage,method: .post,headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                     print(response.result.value)
                     completionHandler(response.result.value, nil)
                }
                
            case .failure(let encodingError):
                completionHandler(nil, encodingError.localizedDescription)
            }
        }

    }
    func uploadFilesWithType(_ parameters: [String: String],URL_UploadImage: String,arrData: [PhotoModel],completionHandler: @escaping (String?, String?) -> ()){
        requestSaveFileWithType(parameters, URL_UploadImage: URL_UploadImage, arrData: arrData, completionHandler: completionHandler)
        
    }
    func requestSaveFileWithType(_ parameters: [String: String],URL_UploadImage: String,arrData: [PhotoModel],completionHandler: @escaping (String?, String?) -> ()){
       
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for i in 0 ..< arrData.count {
                //let imgData = UIImageJPEGRepresentation(arrImage[i], 1)!
                //multipartFormData.append(arrData[i], withName: "fileset",fileName: fileName, mimeType: "image/jpg")
                //multipartFormData.append(arrData[i].ImageData!, withName: "fileset",fileName: arrData[i].ImageType!, mimeType: arrData[i].MimeType!)
                
                	
            }
            
            
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:URL_UploadImage,method: .post,headers: nil)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                    completionHandler(response.result.value, nil)
                }
                
            case .failure(let encodingError):
                completionHandler(nil, encodingError.localizedDescription)
            }
        }
        
    }
    func uploadFile(_ url:String,fileData: Data, fileName:String,mimeType:String = "image/jpg", parameters: [String: String]? = nil,completionHandler: @escaping (String?, String?) -> ()){
        let headers = ["Content-Type": "application/json"]
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(fileData, withName: "fileset",fileName: fileName, mimeType: mimeType)
            if(parameters != nil){
                for (key, value) in parameters! {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        },to:url,method: .post,headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                    completionHandler(response.result.value, nil)
                }
                
            case .failure(let encodingError):
                completionHandler(nil, encodingError.localizedDescription)
            }
        }
        
    }
    func sendJSON(_ url:String,fileData: Data, fileName:String,mimeType:String = "application/json",completionHandler: @escaping (String?, String?) -> ()){
        
        self.acessToken = Defaults.getUser(key: "LOGIN")!.access_token
        self.employeeId = Defaults.getUser(key: "LOGIN")!.employeeId
        self.passWord = Defaults.getUser(key: "LOGIN")!.password
        let credentialData = "\(employeeId):\(passWord)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)",
            "ACCESS_TOKEN": acessToken,
            "Content-Type": "application/json"]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileData, withName: "fileset",fileName: fileName, mimeType: mimeType)
        },to:url,method: .post,headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                    print(response)
                    completionHandler(response.result.value, nil)
                }
                
            case .failure(let encodingError):
                completionHandler(nil, encodingError.localizedDescription)
            }
        }
        
    }
    func requestJSON(_ url:String,jsonData: Data,completionHandler: @escaping (_ json: AnyObject?)  -> ()){
        var request = URLRequest(url: URL(string: url)!)
        self.acessToken = Defaults.getUser(key: "LOGIN")!.access_token
        self.employeeId = Defaults.getUser(key: "LOGIN")!.employeeId
        self.passWord = Defaults.getUser(key: "LOGIN")!.password
        let credentialData = "\(employeeId):\(passWord)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(acessToken, forHTTPHeaderField: "ACCESS_TOKEN")
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        Alamofire.request(request).responseString
            { (response:DataResponse<String>) in
                print(response)
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        // print("YOUR JSON DATA>>  \(response.data!)")
                        completionHandler(data as AnyObject?)
                        
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error)
                    // SVProgressHUD.dismiss()
                  //  Function.Message("Thông báo", message: "Mạng không ổn đinh,vui lòng thử lại.")
                    completionHandler(nil)
                    break
                    
                }
        }
    }
    func requestJSONLogin(_ url:String,jsonData: Data,completionHandler: @escaping (_ json: AnyObject?)  -> ()){
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseString
            { (response:DataResponse<String>) in
               // print(response)
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        // print("YOUR JSON DATA>>  \(response.data!)")
                        completionHandler(data as AnyObject?)
                        
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error)
                    // SVProgressHUD.dismiss()
                    //  Function.Message("Thông báo", message: "Mạng không ổn đinh,vui lòng thử lại.")
                    completionHandler(nil)
                    break
                    
                }
        }
    }
    func performRequestLogin(_ method: HTTPMethod, requestURL: String, params: [String: AnyObject], comletion: @escaping (_ json: AnyObject?) -> Void) {
        let credentialData = "\(employeeId):\(passWord)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)",
            "ACCESS_TOKEN": acessToken]
        
        Alamofire.request(requestURL, method: method, parameters: params, headers: headers).responseString { (response:DataResponse<String>) in
            print(response)
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    // print("YOUR JSON DATA>>  \(response.data!)")
                    comletion(data as AnyObject?)
                    
                }
                break
                
            case .failure(_):
                print(response.result.error)
                // SVProgressHUD.dismiss()
                Function.Message("Thông báo", message: "Mạng không ổn đinh,vui lòng thử lại.")
                comletion(nil)
                break
                
            }
        }
    }

    func performRequest(_ method: HTTPMethod, requestURL: String, params: [String: AnyObject], comletion: @escaping (_ json: AnyObject?) -> Void) {
        self.acessToken = Defaults.getUser(key: "LOGIN")!.access_token
        self.employeeId = Defaults.getUser(key: "LOGIN")!.employeeId
        self.passWord = Defaults.getUser(key: "LOGIN")!.password
        let credentialData = "\(employeeId):\(passWord)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)",
                        "ACCESS_TOKEN": acessToken]
        print(params)
        print(requestURL)
        Alamofire.request(requestURL, method: method, parameters: params, headers: headers).responseJSON { (response:DataResponse<Any>) in
           // print(response)
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                   // print("YOUR JSON DATA>>  \(response.data!)")
                    comletion(data as AnyObject?)
                    
                }
                break
                
            case .failure(_):
                print(response.result.error)
               // SVProgressHUD.dismiss()
               // Function.Message("Thông báo", message: "Mạng không ổn đinh,vui lòng thử lại.")
                comletion(nil)
                break
                
            }
        }
    }

    func request(_ method: HTTPMethod, requestURL: String, params: [String: Any], comletion: @escaping (_ json: Data?) -> Void) {
        let credentialData = "\(employeeId):\(passWord)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)",
            "access_token": acessToken]
        print("params: \(params)")
        Alamofire.request(requestURL, method: method, parameters: params, headers: headers).responseData { (response:DataResponse<Data>) in
            print(response)
            
            switch(response.result) {
            case .success(_):
                if let result = response.result.value{
                    print("YOUR JSON DATA>>  \(result)")
                    comletion(result)
                    
                }
                break
                
            case .failure(_):
                print(response.result.error)
                Function.Message("Thông báo", message: "Mạng không ổn đinh,vui lòng thử lại.")
                comletion(nil)
                break
                
            }
        }
    }

	
}
