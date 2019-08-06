//
//  ShopDirectViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/31/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class ShopDirectViewController: UIViewController {
    @IBOutlet weak var myTable: UITableView!
    var _lstMts = [ReportMarketShopModel]()
    var _dataOnlineController: IDataOnline!
    var _login = Defaults.getUser(key: "LOGIN")
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
       
        // Do any additional setup after loading the view.
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
extension ShopDirectViewController: UITableViewDelegate,UITableViewDataSource{
    func updateTableView(){
        myTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lstMts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(_lstMts[indexPath.row].groupBy == nil || _lstMts[indexPath.row].groupBy == ""){
            return 39
        }
        else{
            return 65
        }
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _dataOnlineController.GetShopKeyAccount((_login?.employeeId)!, channelId: _lstMts[indexPath.row].objectId,type: _lstMts[indexPath.row].title,area: _lstMts[indexPath.row].objectName,regionId: 0) { (data, error) in
            if data != nil{
                let controller = self.storyboard?.instantiateViewController(withIdentifier:"frmGetListShop") as! GetListShopViewController
                controller._listShops = data!
                controller._listFilter = data!
                controller._objectName = self._lstMts[indexPath.row].objectName
                controller._lstPS = ["All Shop","Chỉ Shop có PS","Chỉ Shop có ME"]
                if let viewController = self.navigationController{
                    viewController.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellKeyAccount", for: indexPath) as! cellReportMarketShop
        cell.labelShop.text = _lstMts[indexPath.row].objectName
        cell.labelNumOfME.text = "\(_lstMts[indexPath.row].noofME)"
        cell.labelNumOfPs.text = "\(_lstMts[indexPath.row].noofPS)"
        cell.labelNumOfStore.text = "\(_lstMts[indexPath.row].noofShop)"
        if(_lstMts[indexPath.row].groupBy == nil || _lstMts[indexPath.row].groupBy == ""){
            cell.labelTitle.isHidden = true
            cell.heightTitle.constant = 0
        }
        else{
            cell.labelTitle.isHidden = false
            cell.heightTitle.constant = 26
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.labelTitle.text = "\(_lstMts[indexPath.row].title)"
         cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
}
