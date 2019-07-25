//
//  UIViewControllerExtensions.swift
//  BEKOSALES
//
//  Created by Nguyen Tien on 7/2/18.
//  Copyright © 2018 Nguyen Phuc Long. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func pushViewController(withIdentifier:String, sender:UIViewController? = nil) {
        if let controller = storyboard?.instantiateViewController(withIdentifier:withIdentifier){
            if let viewController = self.navigationController{
                viewController.pushViewController(controller, animated: true)
            }
        }
    }
    func pushViewController(viewController:UIViewController, sender:UIViewController? = nil) {
           if let viewController = self.navigationController{
                viewController.pushViewController(viewController, animated: true)
            }
        
    }
    func webView(_ url:String, Arguments: Dictionary<String,Any>,pageName: String){
//        let web = WebViewController()
//        web.url = url
//        web.Arguments = Arguments
//        web.pageName = pageName
//        if let viewController = self.navigationController{
//            viewController.pushViewController(web, animated: true)
//        }
//        else{
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = web
//        }
    }
}
