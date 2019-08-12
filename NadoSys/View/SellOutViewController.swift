//
//  SellOutViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/21/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class SellOutViewController: UIViewController {

    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    var _listDay: [(String,Int,Date)] = []
    var _listSellout = [SellOutModel]()
    var _sellOutController: ISellOut!
    var _dataOfflineController: IDataOffline!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _imageType = 0
    let _type = Preferences.get(key: "SALETYPE")
    @IBOutlet weak var myCollect: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if _type == "SELLOUT"{
            _imageType = (_dataOfflineController.ByObjectName("SaleOut", objectName: "Sale Out")?.objectId)!
        }
        else if _type == "SELLIN"{
            _imageType = (_dataOfflineController.ByObjectName("SaleOut", objectName: "Sell In")?.objectId)!
        }
        else if _type == "SELLTHROUGH"{
            _imageType = (_dataOfflineController.ByObjectName("SaleOut", objectName: "Sell through")?.objectId)!
        }
        else{
            _imageType = 0
        }
        myTable.delegate = self
        myTable.dataSource = self
        myCollect.dataSource = self
        myCollect.delegate = self
        btnAdd.setRounded(radius: 23)
        getNumberDayfromCurrent()
        loadData(Date())
        addRightButton()
        if _type == "SELLOUT"{
            showPopup()
        }
       
        // Do any additional setup after loading the view.
    }
    
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        
        var title = ""
        if _type == "SELLOUT"{
            title = "Sell Out/Số bán"
        }
        else if _type == "SELLIN"{
            title = "Sale In/Nhập hàng"
        }
        else if _type == "SELLTHROUGH"{
            title = "Sell Through"
        }
        else{
            title = "Stock/Tồn kho"
        }
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: title, style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title: "NDS", style:.plain, target:nil, action:nil)
    }
    
    func showPopup(){
        if _listSellout.count == 0{
            let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupSellout") as! PopupSelloutViewController
            self.addChild(popup)
            popup.delegate = self
            popup.view.frame = self.view.frame
            self.view.addSubview(popup.view)
            popup.didMove(toParent: self)
        }
        else{
            if _listSellout.count == 1 && _listSellout[0].productId == -1 {
                btnAdd.isHidden = true
                _listSellout = [SellOutModel]()
                myTable.reloadData()
            }
        }
    }
    
    func loadData(_ date: Date){
        _listSellout = _sellOutController.GetList(_shopId!, empId: (_login?.employeeId)!, saleDate: date.toShortTimeString(),objId: _imageType)!
        labelCount.text = "Số lượng: \(_listSellout.reduce(0,{$0 + $1.qty}))"
        let total = _listSellout.reduce(0, {$0 + Double($1.qty)*$1.price})
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let price = numberFormatter.string(from: NSNumber(value: total))
        labelPrice.text = "Thành tiền: \(price!)"
        myTable.reloadData()
        if date.toShortTimeString() == Date().toShortTimeString(){
            btnAdd.isHidden = false
        }
        else{
            btnAdd.isHidden = true
        }
    }
    
    func getNumberDayfromCurrent(){
        var currentDate = Date()
        for i in 0...6 {
            currentDate.changeDays(by: i == 0 ? 0 : -1)
            _listDay.append((currentDate.getNameOfDay(),currentDate.day(),currentDate))
            // Do something
        }
        _listDay = _listDay.reversed()
        updateUI()
    }

  
    @IBAction func create(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmCreateSellOut") as! CreateSellOutViewController
        controller.delegate = self
        controller._type = _type
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
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
extension SellOutViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func updateUI(){
        myCollect.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _listDay.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<_listDay.count {
            let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0) ) as! cellCollectDate
            if i == indexPath.row{
                cell.setBorder(radius: 0, color: UIColor(netHex: 0x1966a7))
            }
            else{
                cell.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
            }
        }
        loadData(_listDay[indexPath.row].2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // In this function is the code you must implement to your code project if you want to change size of Collection view
        let width  = (self.view.frame.width - 70)/7
        return CGSize(width: width, height: 49)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollect.dequeueReusableCell(withReuseIdentifier: "cellCollectDate", for: indexPath) as! cellCollectDate
        cell.labelDay.text = "\(_listDay[indexPath.row].1)"
        cell.labelNameDay.text = _listDay[indexPath.row].0
        if indexPath.row == _listDay.count - 1{
            cell.setBorder(radius: 0, color: UIColor(netHex: 0x1966a7))
        }else{
            cell.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        }
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
extension SellOutViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(_listSellout == nil){
            return 0
        }
        return _listSellout.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellItemSellout", for: indexPath) as! cellItemSellout
        cell.labelQty.text = "\(_listSellout[indexPath.row].qty)"
        cell.labelModel.text = "\(indexPath.row + 1). \(_listSellout[indexPath.row].model)"
        cell.labelCusName.text = "\(_listSellout[indexPath.row].cusName)"
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let price = numberFormatter.string(from: NSNumber(value: _listSellout[indexPath.row].price))
        cell.labelPrice.text = "Giá: \(price!)"
        return cell
        
    }
}
extension SellOutViewController: delegateSellOut{
    func refresh() {
        loadData(Date())
    }
    
}
extension SellOutViewController: nosellDelegate{
    func disableAddSellout() {
        btnAdd.isHidden = true
    }
}

