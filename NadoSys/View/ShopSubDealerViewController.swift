//
//  ShopSubDealerViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/31/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class ShopSubDealerViewController: UIViewController {

    @IBOutlet weak var myTable: UITableView!
    var _lstGts = [ReportMarketShopModel]()
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
extension ShopSubDealerViewController: UITableViewDelegate,UITableViewDataSource{
    func updateTableView(){
        myTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lstGts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(_lstGts[indexPath.row].groupBy == nil || _lstGts[indexPath.row].groupBy == ""){
            return 35
        }
        else{
            return 61
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _dataOnlineController.GetShopKeyAccount((_login?.employeeId)!, channelId: _lstGts[indexPath.row].objectId,type: _lstGts[indexPath.row].title,area: _lstGts[indexPath.row].objectName,regionId: _lstGts[indexPath.row].objectId) { (data, error) in
            if data != nil{
                let controller = self.storyboard?.instantiateViewController(withIdentifier:"frmGetListShop") as! GetListShopViewController
                controller._listShops = data!
                controller._listFilter = data!
                controller._objectName = self._lstGts[indexPath.row].objectName
                controller._lstPS = ["All Shop","Chỉ Shop có LSR"]
                if let viewController = self.navigationController{
                    viewController.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRegion", for: indexPath) as! cellReportMarketShop
        cell.labelNumOfME.text = "\(_lstGts[indexPath.row].noofLSR)"
        cell.labelNumOfStore.text = "\(_lstGts[indexPath.row].noofShop)"
        cell.labelTitle.text = "\(_lstGts[indexPath.row].title)"
        cell.labelShop.text = "\(_lstGts[indexPath.row].objectName)"
        if(_lstGts[indexPath.row].groupBy == nil || _lstGts[indexPath.row].groupBy == ""){
            cell.labelTitle.isHidden = true
            cell.heightTitle.constant = 0
        }
        else{
            cell.labelTitle.isHidden = false
            cell.heightTitle.constant = 26
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.labelTitle.text = "\(_lstGts[indexPath.row].title)"
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
}
