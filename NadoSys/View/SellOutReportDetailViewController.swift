//
//  SellOutReportDetailViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/21/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class SellOutReportDetailViewController: UIViewController {
   
    @IBOutlet weak var labelShopCode: UILabel!
    @IBOutlet weak var myTable: UITableView!
    var _fromDate = ""
    var _toDate = ""
    var _type = ""
    var _month = 0
    var _week = 0
    var _year = 0
    var _date = ""
    @IBOutlet weak var labelDate: UILabel!
    
    var _dataOnlineController: IDataOnline!
    var _login = Defaults.getUser(key: "LOGIN")
    var _lstReport = [SellOutReportDetailModel]()
    var _sellout = SellOutReportModel()
    override func viewDidLoad() {
        myTable.delegate = self
        myTable.dataSource = self
        super.viewDidLoad()
        updateUI()
        loaddata(_fromDate, toDate: _toDate)
        // Do any additional setup after loading the view.
    }
    
    func updateUI(){
        labelShopCode.text = "\(_sellout.shopCode),\(_sellout.shopName)"
        if _type == "DAILY"{
            labelDate.text = "Date: \(Date().toShortTimeString())"
        }
        else if _type == "WEEKLY"{
            labelDate.text = "Week: \(_week)-\(_year)"
        }
        else{
            labelDate.text = "Month: \(_month)-\(_year)"
        }
    }
    
    func loaddata(_ fromDate: String,toDate: String){
        SVProgressHUD.show()
        _dataOnlineController.GetSellOutReportDetail((_login?.employeeId)!,shopId: _sellout.shopId, fromDate: _fromDate,toDate: _toDate) { (data, error) in
            if data != nil{
                if (data?.count)! > 0 {
                    self._lstReport = data!
                }
                
            }
            self.updateTableView()
            SVProgressHUD.dismiss()
            
        }
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
extension SellOutReportDetailViewController: UITableViewDelegate,UITableViewDataSource{
    func updateTableView(){
        myTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lstReport.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 213
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSellOutReportDetail", for: indexPath) as! cellSellOutReportDetail
        cell.lableName.text = _lstReport[indexPath.row].cusName
        cell.labelPhone.text = _lstReport[indexPath.row].cusPhone
        cell.labelAddress.text = _lstReport[indexPath.row].cussAdd
        cell.labelSaleDate.text = "Date: \(_lstReport[indexPath.row].dateString)"
        let actual =  "\(_lstReport[indexPath.row].amount)"
        cell.labelAmount.text = actual.toTarget()
        cell.items = _lstReport[indexPath.row].items
        cell.updateTableView()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
}
