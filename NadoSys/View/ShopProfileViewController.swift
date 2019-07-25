//
//  ShopProfileViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/24/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import SwiftyJSON
class ShopProfileViewController: UIViewController {

    @IBOutlet weak var labelSale: UILabel!
    @IBOutlet weak var labelTotalStock: UILabel!
    @IBOutlet weak var labelCurentDisplay: UILabel!
    @IBOutlet weak var labelShopContact: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelSheftCompetitor: UILabel!
    @IBOutlet weak var labelSheftSeft: UILabel!
    @IBOutlet weak var labelShopsize: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelContact: UILabel!
    @IBOutlet weak var labelUpdate: UILabel!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _dataOnlineController: IDataOnline!
    var _shop = ShopModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        let queue = DispatchQueue(label: "com.shopprofile")
        queue.async {
            self.loadShopInfo()
        }
        // Do any additional setup after loading the view.
    }
    
    func loadShopInfo(){
        _dataOnlineController.GetShopById(_shopId!) { (data, error) in
            DispatchQueue.main.async {
                if data != nil{
                    self._shop = data!
                    self.setData()
                }
            }
            
        }
    }
    
    
    func setData(){
        let jsonData = JSON(_shop.item)
       
            print(jsonData)
            labelContact.text = jsonData["contactName"].stringValue
            labelPhone.text = jsonData["contactPhone"].stringValue
            labelShopsize.text = jsonData["shopSize"].stringValue
            labelSheftSeft.text = jsonData["sheltOfself"].stringValue == "1" ? "Yes" : "No"
            labelSheftCompetitor.text = jsonData["sheltOfCompetitor"].stringValue == "1" ? "Yes" : "No"
            if jsonData["status"].stringValue ==  "1"
            {
                labelStatus.text = "Close"
            }
            else if jsonData["status"].stringValue ==  "2"{
                labelStatus.text = "Open"
            }
            else{
                labelStatus.text = "Moved"
            }
            labelNote.text = jsonData["note"].stringValue
            labelShopContact.text = jsonData["contactWithShop"].stringValue
        
    }
    
    
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Shop profile", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title:"NDS", style:.plain, target:nil, action:nil)
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x1966a7)
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        addRightButton()
    }

    
    @IBAction func update(_ sender: Any) {
        pushViewController(withIdentifier: "frmUpdateShop")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
