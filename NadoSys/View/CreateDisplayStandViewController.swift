//
//  CreateDisplayStandViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/19/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class CreateDisplayStandViewController: UIViewController {

    @IBOutlet weak var widthScan: NSLayoutConstraint!
    @IBOutlet weak var btnScan: UIButton!
    var _delegate: delegateRefeshCollectData?
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var viewPOSMCode: UIView!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtPOSMCode: UITextField!
    @IBOutlet weak var txtPOSM: UITextField!
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewPOSM: UIView!
    var _listPOSM = [ObjectDataModel]()
    var _listStatus = [ObjectDataModel]()
    var _posmId: Int = 0
    var _statusId: Int = 0
    var _dataOfflineController: IDataOffline!
    var _dataOnlineController: IDataOnline!
    var _displayStandController: IDisplayStand!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    override func viewDidLoad() {
        super.viewDidLoad()
        widthScan.constant = 0
        initData()
        setLayout()
        setEventView()
        
        // Do any additional setup after loading the view.
    }
    func initData(){
        let queue = DispatchQueue(label: "initObjectData")
        queue.async {
            self._listPOSM = self._dataOfflineController.GetListObjectDatas("POSM")!
            self._listStatus = self._dataOfflineController.GetListObjectDatas("POSM_STATUS")!
        }
    }
    func setEventView(){
        let gesturePOSM = UITapGestureRecognizer(target: self, action:  #selector(self.getPOSM))
        self.viewPOSM.addGestureRecognizer(gesturePOSM)
        let gestureStatus = UITapGestureRecognizer(target: self, action:  #selector(self.getStatus))
        self.viewStatus.addGestureRecognizer(gestureStatus)
    }
    
    @IBAction func scan(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmQRScan") as! QRScanViewController
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
    }
    func setLayout(){
        txtValue.textAlignment = .center
        viewPOSM.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        viewPOSMCode.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        viewStatus.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        viewNote.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
    }
    @IBAction func inscrease(_ sender: Any) {
        cal(1)
    }
    @IBAction func decrease(_ sender: Any) {
        cal(-1)
    }
    func cal(_ size: Int){
        let quantity = Int(txtValue.text!)! + size
        if quantity < 0 {
            Function.Message("Info", message: "The number must be greater than or equal to 0")
            return
        }
        txtValue.text = "\(quantity)"
    }
    @objc func getPOSM(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmObjectDataList") as! ObjectDataListViewController
        controller._objectName = txtPOSM.text!
        controller._listObjs = _listPOSM
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
    }
    @objc func getStatus(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmObjectDataList") as! ObjectDataListViewController
        controller._objectName = txtStatus.text!
        controller._listObjs = _listStatus
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
        
        //pushViewController(withIdentifier: "frmModelList")
    }
    
    func validate() -> Bool {
        if txtPOSM.text == "" {
            Function.Message("Thông báo", message: "Bạn chưa chọn POSM.")
            return false
        }
        if txtStatus.text == "" {
            Function.Message("Thông báo", message: "Bạn chưa chọn trạng thái.")
            return false
        }
        return true
    }
    
    func toJson(_ item: DisplayStandModel) -> [Dictionary<String, AnyObject>] {
        var promotionResults: [Dictionary<String, AnyObject>] = []
        
        let dictS  : [String : AnyObject] = [
            "Id": 0 as AnyObject,
            "EmployeeId": item.employeeId as AnyObject,
            "ShopId": item.shopId as AnyObject,
            "ReportDate": item.reportDate as AnyObject,
            "CreatedDate": item.createdDate as AnyObject,
            "PosmId": item.posmId as AnyObject,
            "Quantity": item.qty as AnyObject,
            "Barcode": item.barcode as AnyObject,
            "Note": item.note as AnyObject,
            "Status": item.status as AnyObject
        ]
        promotionResults.append(dictS )
        
        return promotionResults
    }
    
    
    @IBAction func save(_ sender: Any) {
        if validate(){
            let display = DisplayStandModel()
            display.status = _statusId
            display.statusName = txtStatus.text!
            display.note = txtNote.text!
            display.employeeId = (_login?.employeeId)!
            display.shopId = _shopId!
            display.createdDate = Date().toLongTimeString()
            display.reportDate = Date().toShortTimeString()
            display.posmName = txtPOSM.text!
            display.barcode = txtPOSMCode.text!
            display.posmId = _posmId
            display.changed = 0
            display.id = 0
            display.qty = Int(txtValue.text!)!
            _displayStandController.InsertStand(display)
            SVProgressHUD.show()
            _dataOnlineController.SaveInfo(Function.getJson(toJson(display)), url: URLs.URL_DISPLAYSTAND_SAVEDATA) { (data, error) in
                if data != nil{
                    self._delegate?.refresh()
                    guard(self.navigationController?.popViewController(animated: true)) != nil
                        else{
                            self.dismiss(animated: true, completion: nil)
                            return
                    }
                }
                SVProgressHUD.dismiss()
            }
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
extension CreateDisplayStandViewController: delegateSelectObjectData{
    func get(_ object: ObjectDataModel) {
        if object.objectType == "POSM"{
            txtPOSM.text = object.objectName
            _posmId = object.objectId
        }
        else if object.objectType == "POSM_STATUS"{
            txtStatus.text = object.objectName
            _statusId = object.objectId
        }
        if object.isScaner == 1 {
            btnScan.isHidden = false
            widthScan.constant = 34
        }
        else{
            btnScan.isHidden = true
            widthScan.constant = 0
        }
    }
    
    
}
extension CreateDisplayStandViewController: scanBarcodeDelegate{
    func getBarCode(_ barcode: String) {
        txtPOSMCode.text = barcode
    }
}
