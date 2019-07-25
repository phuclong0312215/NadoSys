//
//  POSMViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/20/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class POSMViewController: UIViewController {
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var btnPhoto: UIButton!
    var _listDay: [(String,Int,Date)] = []
    var _listPOSM = [POSMModel]()
    var _dataOnlineController: IDataOnline!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _indexPath = 6
    var _type = Preferences.get(key: "POSMTYPE")
    var _url = ""
    @IBOutlet weak var myCollect: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        myCollect.dataSource = self
        myCollect.delegate = self
        btnAdd.setRounded(radius: 23)
        btnPhoto.setRounded(radius: 23)
        getNumberDayfromCurrent()
        loadData(Date())
        addRightButton()
        if _type == "STOCK"{
            _shopId = 0
            _url = URLs.URL_POSM_GETDATA_STOCK
            btnPhoto.isHidden = true
        }
        else{
            _url = URLs.URL_POSM_GETDATA_RESULT
        }
        // Do any additional setup after loading the view.
    }
    func loadData(_ date: Date){
        if _type == "STOCK"{
            _url = URLs.URL_POSM_GETDATA_STOCK
        }
        else{
            _url = URLs.URL_POSM_GETDATA_RESULT
        }
        SVProgressHUD.show()
        _dataOnlineController.GetPosmList((_login?.employeeId)!,type: _type, shopId: _shopId!, reportDate: date.toShortTimeString(),url: _url) { (data, error) in
            DispatchQueue.main.async {
                if data != nil{
                    self._listPOSM = data!
                    self.labelCount.text = "Số lượng: \(self._listPOSM.reduce(0,{$0 + $1.quantity}))"
                    
                }
                else{
                    self._listPOSM = [POSMModel]()
                }
                self.myTable.reloadData()
                SVProgressHUD.dismiss()
            }
                
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
    
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        let title = _type == "STOCK" ? "Nhập tồn POSM" : "Triển khai POSM"
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: title, style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title: "NDS", style:.plain, target:nil, action:nil)
    }
    
    @IBAction func create(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmCreatePOSM") as! CreatePOSMViewController
        controller._delegate = self
        controller._type = _type
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
    }

   
    @IBAction func takeImage(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmPOSMImage") as! POSMImageViewController
        controller._date = _listDay[_indexPath].2
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
extension POSMViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
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
        _indexPath = indexPath.row
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
extension POSMViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(_listPOSM == nil){
            return 0
        }
        return _listPOSM.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPosm", for: indexPath) as! cellPosm
        cell.labeQty.text = "\(_listPOSM[indexPath.row].quantity)"
        cell.posmName.text = "\(indexPath.row + 1). \(_listPOSM[indexPath.row].itemName)"
         cell.posmCode.text = "\(_listPOSM[indexPath.row].itemCode)"
      
        return cell
        
    }
}
extension POSMViewController: delegateCreatePosm{
    func refresh() {
       loadData(Date())
    }
    
}


