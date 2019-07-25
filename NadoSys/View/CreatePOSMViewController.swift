//
//  CreatePOSMViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/20/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegateCreatePosm {
    func refresh()
}

class CreatePOSMViewController: UIViewController {
    var _indexPath = 0
    var _type = ""
    var _url = ""
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var myTable: UITableView!
    var _dataOnlineController: IDataOnline!
    var _listPosm = [POSMModel]()
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _delegate: delegateCreatePosm?
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "ic_add_white.png")
        var imageView = UIImageView(frame: CGRect(x: 2, y: 2, width: 22, height: 22))
        imageView.image = image
        btnAdd.addSubview(imageView)
      
        myTable.delegate = self
        myTable.dataSource = self
        heightTable.constant = 0
        addRightButton()
        if _type == "STOCK"{
            _shopId = 0
            _url = URLs.URL_POSM_CREATE_STOCK
            labelTitle.text = "Nhập tồn POSM"
        }
        else{
            _url = URLs.URL_POSM_CREATE
            labelTitle.text = "Triển khai POSM"
        }
        // Do any additional setup after loading the view.
    }
    
    func addRightButton(){
        let title = _type == "STOCK" ? "Nhập tồn POSM" : "Triển khai POSM"
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: title, style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title: "NDS", style:.plain, target:nil, action:nil)
    }
    
    @IBAction func addPosm(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmPOSMListSelect") as! POSMListSelectViewController
        controller._listPosmOlds = _listPosm
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
    }

    @objc func updateValue(_ textField: UITextField){
        let row = textField.tag
        var quantity = 1
        if(textField.text != ""){
            quantity = Int(textField.text!)!
        }
        _listPosm[row].quantity = quantity
    }
    
    func toJson(_ lst: [POSMModel]) -> [Dictionary<String, AnyObject>] {
        var posmResults: [Dictionary<String, AnyObject>] = []
        var dictS  : [String : AnyObject] = [:]
        for item in lst{
            if _type == "STOCK"{
                dictS = [
                    "POSMId": item.id as AnyObject,
                    "EmployeeId": _login?.employeeId as AnyObject,
                    "ShopId": 0 as AnyObject,
                    "ReportDate": Date().toShortTimeString() as AnyObject,
                    "Quantity": item.quantity as AnyObject,
                    "UserName": _login?.userName as AnyObject,
                    "Type": "in" as AnyObject,
                    "PlatForm": "iOS" as AnyObject
                ]
            }
            else{
                dictS = [
                    "POSMId": item.id as AnyObject,
                    "EmployeeId": _login?.employeeId as AnyObject,
                    "ShopId": _shopId as AnyObject,
                    "ReportDate": Date().toShortTimeString() as AnyObject,
                    "Quantity": item.quantity as AnyObject,
                    "UserName": _login?.userName as AnyObject,
                    "PlatForm": "iOS" as AnyObject
                ]
            }
            posmResults.append(dictS )
        }
        return posmResults
    }
    
    
    @IBAction func save(_ sender: Any) {
        SVProgressHUD.show()
        _dataOnlineController.SaveInfo(Function.getJson(toJson(_listPosm)), url: _url) { (data, error) in
            if data != nil{
                DispatchQueue.main.async {
                    self._delegate?.refresh()
                    guard(self.navigationController?.popViewController(animated: true)) != nil
                        else{
                            self.dismiss(animated: true, completion: nil)
                            return
                    }
                }
            }
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
extension CreatePOSMViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(_listPosm == nil){
            return 0
        }
        return _listPosm.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 83
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPosm", for: indexPath) as! cellPosm
        cell.posmCode.text = "\(_listPosm[indexPath.row].itemCode)"
        
        cell.posmName.text = "\(_listPosm[indexPath.row].itemName)"
        
        if _listPosm[indexPath.row].quantity > 0{
            cell.txtValue.text = "\(_listPosm[indexPath.row].quantity)"
        }
        else{
            cell.txtValue.text = "1"
            _listPosm[indexPath.row].quantity = 1
        }
           cell.txtValue.addTarget(self, action: #selector(CreatePOSMViewController.updateValue(_:)), for: UIControl.Event.editingChanged)
        cell.txtValue.tag = indexPath.row
        cell.txtValue.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        cell.btnDecrease.setRounded(radius: 6)
        cell.btnIncrease.setRounded(radius: 6)
        cell._delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
}
extension CreatePOSMViewController: delegateSelectPosm{
    func get(_ listPosm: [POSMModel]) {
        if listPosm != nil && listPosm.count > 0 {
            checkListPosm(listPosm)
            myTable.reloadData()
        }
    }
    func checkListPosm(_ list: [POSMModel]?){
        var i = 0
        for item in self._listPosm {
            let posm = list!.filter{$0.id == item.id}.first
            if posm == nil{
                self._listPosm.remove(at: i)
                heightTable.constant = heightTable.constant - 83
                continue
            }
            i = i + 1
        }
        for item in list! {
            let posm = self._listPosm.filter{$0.id == item.id}.first
            if posm == nil {
                self._listPosm.append(item)
                heightTable.constant = heightTable.constant + 83
            }
        }
        
    }
}
extension CreatePOSMViewController: delegatePosm{
    func cal(for cell: cellPosm, size: Int) {
        guard let indexPath = myTable.indexPath(for: cell) else {
            return
        }
        self._indexPath = indexPath.row
        let quantity = _listPosm[_indexPath].quantity + size
        if quantity < 0 {
            Function.Message("Info", message: "The number must be greater than or equal to 0")
            return
        }
        
        //let total = Double(exactly: _listModel[indexPath.row].quantity)! *
        _listPosm[_indexPath].quantity = quantity
        cell.txtValue.text = "\(quantity)"
    }
    func remove(for cell: cellPosm) {
        guard let indexPath = myTable.indexPath(for: cell) else {
            return
        }
        self._indexPath = indexPath.row
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có xoá posm này", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            self.heightTable.constant = self.heightTable.constant - 83
            self._listPosm.remove(at: self._indexPath)
            self.myTable.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            guard(self.navigationController?.popViewController(animated: true)) != nil
                else{
                    self.dismiss(animated: true, completion: nil)
                    return
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
