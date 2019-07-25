//
//  Reachability.swift
//  SkyWorth
//
//  Created by HappyDragon on 3/16/16.
//  Copyright © 2016 acacy. All rights reserved.
//

import Foundation
import SystemConfiguration

open class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var Status:Bool = false
        let url = URL(string: "http://google.com.vn")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: URLResponse?
        do{
            var data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as Data?
            
        }
        catch{
            print("error")
        }
        
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
    
}
