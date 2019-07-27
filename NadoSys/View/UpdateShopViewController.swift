//
//  UpdateShopViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/9/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift
import MapKit
import CoreLocation
class UpdateShopViewController: UIViewController {

    @IBOutlet weak var labelIsWait: UILabel!
    @IBOutlet weak var txtShopCode: UILabel!
    @IBOutlet weak var txtChannel: UITextField!
    @IBOutlet weak var viewChannel: UIView!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var txtWard: UITextField!
    @IBOutlet weak var viewWard: UIView!
    @IBOutlet weak var txtDistrict: UITextField!
    @IBOutlet weak var txtProvince: UITextField!
    @IBOutlet weak var viewDistrict: UIView!
    @IBOutlet weak var viewProvince: UIView!
    @IBOutlet weak var txtVilla: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtHouseNumber: UITextField!
    @IBOutlet weak var txtShopName: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cbCall: BEMCheckBox!
    @IBOutlet weak var cbVisit: BEMCheckBox!
    @IBOutlet weak var cbMoved: BEMCheckBox!
    @IBOutlet weak var cbOpen: BEMCheckBox!
    @IBOutlet weak var cbShelfCompetitorYes: BEMCheckBox!
    @IBOutlet weak var cbClose: BEMCheckBox!
    @IBOutlet weak var cbShelfCompetitorNo: BEMCheckBox!
    @IBOutlet weak var cbShelfNoAQUA: BEMCheckBox!
    @IBOutlet weak var cbShelfYesAQUA: BEMCheckBox!
    @IBOutlet weak var txtShopSize: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _dataOnlineController: IDataOnline!
    var _dataOfflineController: IDataOffline!
    var _shop = ShopModel()
    var groupShelfCompetitor: BEMCheckBoxGroup = BEMCheckBoxGroup()
    var groupShelfAQUA: BEMCheckBoxGroup = BEMCheckBoxGroup()
    var groupShelfStatus: BEMCheckBoxGroup = BEMCheckBoxGroup()
    var groupContactShop: BEMCheckBoxGroup = BEMCheckBoxGroup()
    var _provinceId = 0
    var _districtId = 0
    var _wardId = 0
    var _channelId = 0
    var _latitude: Double = 0
    var _longitude: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setGroupCheckbox()
        setEventView()
        let queue = DispatchQueue(label: "com.updateshopprofile")
        queue.async {
            self.loadShopInfo()
        }
        // Do any additional setup after loading the view.
    }
    func setGroupCheckbox(){
        cbShelfCompetitorNo.boxType = .circle
        cbShelfCompetitorYes.boxType = .circle
        groupShelfCompetitor.addCheckBox(toGroup: cbShelfCompetitorNo)
        groupShelfCompetitor.addCheckBox(toGroup: cbShelfCompetitorYes)
        cbShelfCompetitorNo.on = true
        cbShelfNoAQUA.boxType = .circle
        cbShelfYesAQUA.boxType = .circle
        groupShelfAQUA.addCheckBox(toGroup: cbShelfYesAQUA)
        groupShelfAQUA.addCheckBox(toGroup: cbShelfNoAQUA)
        cbShelfNoAQUA.on = true
        cbOpen.boxType = .circle
        cbClose.boxType = .circle
        cbMoved.boxType = .circle
        groupShelfStatus.addCheckBox(toGroup: cbOpen)
        groupShelfStatus.addCheckBox(toGroup: cbClose)
        groupShelfStatus.addCheckBox(toGroup: cbMoved)
        cbOpen.on = true
        cbCall.boxType = .circle
        cbVisit.boxType = .circle
        groupContactShop.addCheckBox(toGroup: cbCall)
        groupContactShop.addCheckBox(toGroup: cbVisit)
        cbVisit.on = true
    }

    func setEventView(){
        let gestureProvince = UITapGestureRecognizer(target: self, action:  #selector(self.getProvince))
        self.viewProvince.addGestureRecognizer(gestureProvince)
        let gestureDistrict = UITapGestureRecognizer(target: self, action:  #selector(self.getDistrict))
        self.viewDistrict.addGestureRecognizer(gestureDistrict)
        let gestureWard = UITapGestureRecognizer(target: self, action:  #selector(self.getWard))
        self.viewWard.addGestureRecognizer(gestureWard)
        let gestureChannel = UITapGestureRecognizer(target: self, action:  #selector(self.getChannel))
        self.viewChannel.addGestureRecognizer(gestureChannel)
    }
    
    @objc func getProvince(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmLocation") as! LocationViewController
        controller._locationId = _provinceId
        controller._type = "PROVINCE"
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
        
        //pushViewController(withIdentifier: "frmModelList")
    }
    
    @objc func getDistrict(){
        if _provinceId == 0 {
            Function.Message("Info", message: "Bạn chưa chọn Tỉnh/Thành phố")
            return
        }
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmLocation") as! LocationViewController
        controller._locationId = _districtId
        controller._provinceId = _provinceId
        controller._type = "DISTRICT"
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
        
        //pushViewController(withIdentifier: "frmModelList")
    }
    
    @objc func getWard(){
        if _provinceId == 0 {
            Function.Message("Info", message: "Bạn chưa chọn Tỉnh/Thành phố")
            return
        }
        if _districtId == 0 {
            Function.Message("Info", message: "Bạn chưa chọn Quận/Huyện")
            return
        }
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmLocation") as! LocationViewController
        controller._locationId = _wardId
        controller._provinceId = _provinceId
        controller._districtId = _districtId
        controller._type = "WARD"
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
        
        //pushViewController(withIdentifier: "frmModelList")
    }
    
    @objc func getChannel(){
        let _listBrand = self._dataOfflineController.GetListObjectDatas("ACCOUNT")!
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmObjectDataList") as! ObjectDataListViewController
        controller._objectName = txtChannel.text!
        controller._listObjs = _listBrand
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
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
        if _shop.isWait == 1{
            labelIsWait.isHidden = false
        }
        else{
            labelIsWait.isHidden = true
        }
        print(jsonData)
        txtContact.text = jsonData["contactName"].stringValue
        txtPhone.text = jsonData["contactPhone"].stringValue
        txtShopSize.text = jsonData["shopSize"].stringValue
        if jsonData["shelfAqua"].stringValue == "1"{
            cbShelfYesAQUA.on = true
        }
        else{
            cbShelfNoAQUA.on = true
        }
        if jsonData["shelfCompe"].stringValue == "1"{
            cbShelfCompetitorYes.on = true
        }
        else{
            cbShelfCompetitorNo.on = true
        }
        
        if jsonData["shopStatus"].stringValue == "1"{
            cbClose.on = true
        }
        else if jsonData["shopStatus"].stringValue == "2"{
            cbOpen.on = true
        }
        else{
            cbMoved.on = true
        }

        
        if jsonData["contactShop"].stringValue == "Call"{
            cbCall.on = true
        }
        else{
            cbVisit.on = true
        }
        txtShopCode.text = _shop.shopCode
        txtShopName.text = _shop.shopName
        txtHouseNumber.text = _shop.noofHouse
        txtStreet.text = _shop.street
        txtVilla.text = _shop.village
        txtProvince.text = _shop.city
        _provinceId = _shop.provinceId
        txtDistrict.text = _shop.district
        _districtId = _shop.districtId
        txtWard.text = _shop.ward
        _wardId = _shop.wardId
        txtAddress.text = _shop.address
        txtChannel.text = _shop.objectName
        _channelId = _shop.objectId
        if _shop.latitude > 0 && _shop.longitude > 0 {
            let location = CLLocationCoordinate2D(latitude: _shop.latitude,longitude: _shop.longitude)
            zoom(location)
        }
        else{
            let address = "\(txtHouseNumber.text!) \(txtStreet.text!) \(txtVilla.text!),\(txtWard.text!),\(txtProvince.text!),\(txtProvince.text!)"
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        // handle no location found
                        return
                }
               
                let location2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.zoom(location2D)
                // Use your location
            }
        }
       // _districtId = _shop.districtId
    }
    
    func zoom(_ location: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = _shop.shopName
        mapView.addAnnotation(annotation)
    }
    
    func toJson(_ item: ShopModel) -> Data{
        let jsonData = JSON(item.item)
        var jsonString:String = ""
        let sheltOfself = cbShelfYesAQUA.on ? "1" : "0"
        let sheltOfCompetitor = cbShelfCompetitorYes.on ? "1" : "0"
        let contactWithShop = cbCall.on ? "Call" : "Visit"
        var status = ""
        if cbClose.on{
            status = "1"
        }
        else if cbOpen.on{
            status = "2"
        }
        else{
            status = "3"
        }
//        let jsonValue = "{\"contactName\":\"\(txtContact.text!)\",\"contactPhone\":\"\(txtPhone.text!)\",\"shopSize\":\"\(txtShopSize.text!)\",\"sheltOfself\":\"\(sheltOfself)\",\"sheltOfCompetitor\":\"\(sheltOfCompetitor)\",\"status\":\"\(status)\",\"note\":\"\",\"contactWithShop\":\"\(contactWithShop)\"}"

        let jsonValue: [String : AnyObject] = [
            "employeeId": item.employeeId as AnyObject,
            "shopId": _shopId as AnyObject,
            "reportDate": Date().toShortTimeString() as AnyObject,
            "contactName": txtContact.text as AnyObject,
            "contactPhone": txtPhone.text as AnyObject,
            "shopSize": txtShopSize.text as AnyObject,
            "shelfAqua": sheltOfself as AnyObject,
            "shelfCompe": sheltOfCompetitor as AnyObject,
            "shopStatus": status as AnyObject,
            "contactShop": contactWithShop as AnyObject,
            "note": "" as AnyObject,
        ]
        let json  : [String : AnyObject] = [
            "employeeId": item.employeeId as AnyObject,
            "shopId": _shopId as AnyObject,
            "reportDate": Date().toShortTimeString() as AnyObject,
            "shopCode": item.shopCode as AnyObject,
            "newCode": item.newCode as AnyObject,
            "shopName": item.shopName as AnyObject,
            "address": item.address as AnyObject,
            "area": item.area as AnyObject,
            "districtId": _districtId as AnyObject,
            "district": txtDistrict.text as AnyObject,
            "provinceId": _provinceId as AnyObject,
            "city": txtProvince.text as AnyObject,
            "regionId": item.regionId as AnyObject,
            "region": item.region as AnyObject,
            "objectId": _channelId as AnyObject,
            "objectName": txtChannel.text as AnyObject,
            "noofHouse": txtHouseNumber.text as AnyObject,
            "street": txtStreet.text as AnyObject,
            "village": txtVilla.text as AnyObject,
            "latitude": _latitude as AnyObject,
            "longitude": _longitude as AnyObject,
            "wardId": _wardId as AnyObject,
            "ward": txtWard.text as AnyObject,
            "attributes": jsonValue as AnyObject,
        ]
        
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options:.prettyPrinted)
            jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            
        }
        catch let error as NSError{
            print(error.description)
        }
        print(jsonString)
        return jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)!
        
    }
    
    func validate() -> Bool {
        if txtShopName.text == ""{
            Function.Message("Thông báo", message: "Bạn chưa nhập tên cửa hàng")
            return false
        }
        if _provinceId == 0 {
            Function.Message("Thông báo", message: "Bạn chưa chọn Tỉnh/Thành phố")
            return false
        }
        if _districtId == 0 {
            Function.Message("Thông báo", message: "Bạn chưa chọn Quận/Huyện")
            return false
        }
        if _wardId == 0 {
            Function.Message("Thông báo", message: "Bạn chưa chọn Phường/Xã")
            return false
        }
        if _channelId == 0 {
            Function.Message("Thông báo", message: "Bạn chưa chọn Channel")
            return false
        }
        if txtContact.text == ""{
            Function.Message("Thông báo", message: "Bạn chưa nhập người liên hệ")
            return false
        }
//        if txtPhone.text == "" {
//            Function.Message("Thông báo", message: "Bạn chưa nhập số điện thoại")
//            return false
//        }
        if txtShopSize.text == "" {
            Function.Message("Thông báo", message: "Bạn chưa nhập kích thước cửa hàng")
            return false
        }
        return true
    }
    
    @IBAction func save(_ sender: Any) {
        
        if validate(){
            SVProgressHUD.show()
            _dataOnlineController.SaveInfo(toJson(_shop), url: URLs.URL_SHOP_SAVE) { (data, error) in
                if data != nil {
                    DispatchQueue.main.async {
                        self.view.makeToast("Lưu thành công")
                    }
                }
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Cập nhật thông tin cửa hàng", style:.plain, target:nil, action:nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UpdateShopViewController: locationDelegate{
    func setLocation(_ location: RegionSelectModel, locationType: String) {
        if locationType == "PROVINCE"{
            if _provinceId != location.id{
                _provinceId = location.id
                txtProvince.text = location.name_vn
                _districtId = 0
                txtDistrict.text = ""
                txtWard.text = ""
                _wardId = 0
            }
            
        }
        else if locationType == "DISTRICT"{
            if _districtId != location.id{
                _districtId = location.id
                txtDistrict.text = location.name_vn
                txtWard.text = ""
                _wardId = 0
            }
        }
        else{
            _wardId = location.id
            txtWard.text = location.name_vn
        }
    }
}
extension UpdateShopViewController: delegateSelectObjectData{
    func get(_ object: ObjectDataModel) {
        _channelId = object.objectId
        txtChannel.text = object.objectName
        
    }
}
