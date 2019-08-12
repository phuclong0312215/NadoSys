//
//  CreateSellOutViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/22/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import Toast_Swift
protocol delegateSellOut{
    func refresh()
}
class CreateSellOutViewController: UIViewController {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewLayoutSupplier: UIView!
    @IBOutlet weak var txtSupplier: UITextField!
    @IBOutlet weak var heightSupplier: NSLayoutConstraint!
    @IBOutlet weak var viewSupplier: UIView!
    @IBOutlet weak var heightViewCus: NSLayoutConstraint!
    @IBOutlet weak var viewCus: UIView!
    var camera: Camera!
    @IBOutlet weak var txtCusName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewCusName: UIView!
    var delegate: delegateSellOut?
    var _type: String = ""
    var _supplierId: Int = 0
    var _indexPath: Int = 0
    var _model: String = ""
    var _listModel = [ProductModel]()
    var _sellOutController: ISellOut!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var myTable: UITableView!
    var _dataOfflineController: IDataOffline!
    var _dataOnlineController: IDataOnline!
    var _imageListController: IImageList!
    var photo = ImageListModel()
    var _listPhoto = [ImageListModel]()
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _shopName = Preferences.get(key: "SHOPNAME")
    var _guid: String = ""
    var _imageType: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "ic_add_white.png")
        var imageView = UIImageView(frame: CGRect(x: 2, y: 2, width: 22, height: 22))
        imageView.image = image
        btnAdd.addSubview(imageView)
        heightSupplier.constant = 0
        viewSupplier.isHidden = true
        viewLayoutSupplier.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        if _type == "SELLOUT"{
            _imageType = (_dataOfflineController.ByObjectName("SaleOut", objectName: "Sale Out")?.objectId)!
        }
        else if _type == "SELLIN"{
            _imageType = (_dataOfflineController.ByObjectName("SaleOut", objectName: "Sell In")?.objectId)!
        }
        else if _type == "SELLTHROUGH"{
            heightSupplier.constant = 85
            viewSupplier.isHidden = false
            _imageType = (_dataOfflineController.ByObjectName("SaleOut", objectName: "Sell through")?.objectId)!
        }
        let gestureSupplier = UITapGestureRecognizer(target: self, action:  #selector(self.getSupplier))
        self.viewLayoutSupplier.addGestureRecognizer(gestureSupplier)
        
        myTable.delegate = self
        myTable.dataSource = self
        heightTable.constant = 0
        setLayout()
        // Do any additional setup after loading the view.
    }
    
    @objc func getSupplier(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmSupplier") as! SupplierListViewController
        controller._supplierId = _supplierId
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
    }
    
    func setLayout(){
        viewAddress.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        viewPhone.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        viewCusName.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        navigationController?.navigationItem.title = _type
        if _type != "SELLOUT"{
            viewCus.isHidden = true
            heightViewCus.constant = 0
        }
    }
    
    @IBAction func scan(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmQRScan") as! QRScanViewController
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
    }
    @IBAction func addModel(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmModelListSellOut") as! ModelListSellOutViewController
        controller._listModelOlds = _listModel
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
    }
    
//    func toJsonStock(_ lst: [SellOutModel]) -> [Dictionary<String, AnyObject>] {
//        var selloutResults: [Dictionary<String, AnyObject>] = []
//        for item in lst{
//            let dictS  : [String : AnyObject] = [
//                "Id": 0 as AnyObject,
//                "ProductId": item.productId as AnyObject,
//                "EmployeeId": item.employeeId as AnyObject,
//                "ShopId": item.shopId as AnyObject,
//                "ReportDate": item.saleDate as AnyObject,
//                "Value": item.qty as AnyObject,
//                "Model": item.model as AnyObject,
//                "Barcode": item.barcode as AnyObject,
//                "ItemGuid": item.guid as AnyObject
//            ]
//            selloutResults.append(dictS )
//        }
//        return selloutResults
//    }
    
    func toJson(_ lst: [SellOutModel]) -> [Dictionary<String, AnyObject>] {
        var selloutResults: [Dictionary<String, AnyObject>] = []
        var dictS  : [String : AnyObject] = [:]
        for item in lst{
            if _type == "STOCK"{
                 dictS = [
                    "Id": 0 as AnyObject,
                    "ProductId": item.productId as AnyObject,
                    "EmployeeId": item.employeeId as AnyObject,
                    "ShopId": item.shopId as AnyObject,
                    "ReportDate": item.saleDate as AnyObject,
                    "Value": item.qty as AnyObject,
                    "Model": item.model as AnyObject,
                    "Barcode": item.barcode as AnyObject,
                    "ItemGuid": item.guid as AnyObject
                ]
            }
            else{
                 dictS = [
                    "Id": 0 as AnyObject,
                    "ProductId": item.productId as AnyObject,
                    "EmployeeId": item.employeeId as AnyObject,
                    "ShopId": item.shopId as AnyObject,
                    "SaleDate": item.saleDate as AnyObject,
                    "Quantity": item.qty as AnyObject,
                    "Price": item.price as AnyObject,
                    "CusName": item.cusName as AnyObject,
                    "CusPhone": item.cusPhone as AnyObject,
                    "CussAdd": item.cusAdd as AnyObject,
                    "BlockStatus": -1 as AnyObject,
                    "ObjId": item.objId as AnyObject,
                    "OrderCode": item.orderCode as AnyObject,
                    "DealerId": item.dealerId as AnyObject,
                    "Model": item.model as AnyObject,
                    "Barcode": item.barcode as AnyObject,
                    "ItemGuid": item.guid as AnyObject
                ]
            }
            selloutResults.append(dictS )
        }
        return selloutResults
    }
    
    func toJsonImage(_ item: ImageListModel) -> Data {
        var jsonString = ""
        let json  : [String : AnyObject] = [
            "id": 0 as AnyObject,
            "EmployeeId": item.empId as AnyObject,
            "ShopId": item.shopId as AnyObject,
            "ReportDate": Date().toShortTimeString() as AnyObject,
            "CategoryCode": item.categorycode as AnyObject,
            "CompetitorId": item.competitorId as AnyObject,
            "ImageType": item.imageType as AnyObject,
            "Timing": Date().toLongTimeString() as AnyObject,
            "ShopName": _shopName as AnyObject,
            "Barcode": item.barcode as AnyObject,
            "Model": item.model as AnyObject,
            "ProductGuid": item.productguid as AnyObject
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
    func getSellOut(_ listSelect: [ProductModel]) -> [SellOutModel]{
        var results = [SellOutModel]()
        let orderCode = UUID().uuidString
        for modelSelect in listSelect {
            let sellout = SellOutModel()
            sellout.saleDate = Date().toShortTimeString()
            sellout.createDate = Date().toLongTimeString()
            sellout.productId = modelSelect.productId
            sellout.shopId = _shopId!
            sellout.employeeId = (_login?.employeeId)!
            sellout.price = modelSelect.price
            sellout.dealerId = _supplierId > 0 ? _supplierId : 0
            sellout.qty = modelSelect.quantity
            sellout.blockStatus = -1
            sellout.cusName = txtCusName.text!
            sellout.cusAdd = txtAddress.text!
            sellout.cusPhone = txtPhone.text!
            sellout.objId = _imageType
            sellout.orderCode = orderCode
            sellout.changed = 0
            sellout.barcode = modelSelect.barcode
            sellout.model = modelSelect.model
            if modelSelect.guid == ""{
                sellout.guid = UUID().uuidString
            }
            else{
                sellout.guid = modelSelect.guid
            }
           // _sellOutController.Insert(sellout)
            results.append(sellout)
        }
        return results
    }
    
    func validate() -> Bool {
        let model = _listModel.filter{$0.model == ""}.first
        if let m = model{
            Function.Message("Thông báo", message: "Bạn chưa nhập tên model cho barcode \(m.barcode)")
            return false
        }
        if txtCusName.text == "" && _type == "SELLOUT"{
            Function.Message("Thông báo", message: "Bạn chưa nhập tên khách hàng")
            return false
        }
        return true
    }
    
    @IBAction func save(_ sender: Any) {
        if validate() {
            var _listSellOut = getSellOut(_listModel)
            _sellOutController.Insert(_listSellOut)
            savePhoto()
            saveOnline(_listSellOut)
        }
    }
 
    func savePhoto(){
        for item in _listPhoto {
            let m = _listModel.filter{$0.guid == item.productguid}.first
            item.model = (m?.model)!
        }
        _imageListController.InsertList(_listPhoto)
    }
    
    func saveOnline(_ lstSellOut: [SellOutModel]){
        var count: Int = 0
        SVProgressHUD.show()
        _dataOnlineController.SaveInfo(Function.getJson(toJson(lstSellOut)), url: _type == "STOCK" ? URLs.URL_STOCK_SAVEDATA : URLs.URL_SELLOUT_SAVEDATA) { (data, error) in
            if data != nil {
                if self._listPhoto != nil && (self._listPhoto.count) > 0{
                    for item in self._listPhoto{
                        var arrData = [Data]()
                        let image = UIImage(contentsOfFile: Function.getPath(item.urlimage))!
                        arrData.append(image.pngData()!)
                        arrData.append(self.toJsonImage(item))
                        self._dataOnlineController.UploadDisplay(URLs.URL_SELLOUT_SAVEIMAGE, data: arrData, completionHandler: { (data, error) in
                            DispatchQueue.main.async {
                                if data != nil{
                                    count = count + 1
                                    if count == self._listPhoto.count{
                                        SVProgressHUD.dismiss()
                                        self.view.makeToast("Lưu thành công.")
                                        self.delegate?.refresh()
                                        guard(self.navigationController?.popViewController(animated: true)) != nil
                                            else{
                                                self.dismiss(animated: true, completion: nil)
                                                return
                                        }
                                    }
                                }
                            }
                        })
                    }
                }
                else{
                    SVProgressHUD.dismiss()
                    self.view.makeToast("Lưu thành công.")
                    self.delegate?.refresh()
                    guard(self.navigationController?.popViewController(animated: true)) != nil
                        else{
                            self.dismiss(animated: true, completion: nil)
                            return
                    }
                }
            }
            else{
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @objc func updateValue(_ textField: UITextField){
        let row = textField.tag
        var quantity = 1
        if(textField.text != ""){
            quantity = Int(textField.text!)!
        }
        _listModel[row].quantity = quantity
    }
    
    @objc func updateModel(_ textField: UITextField){
        let row = textField.tag
        _listModel[row].model = textField.text!
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
extension CreateSellOutViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(_listModel == nil){
            return 0
        }
        return _listModel.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if _listModel[indexPath.row].isScan == 0 {
            return 100
        }else{
            return 150
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSellOut", for: indexPath) as! cellSellout
        cell.labelCate.text = "\(_listModel[indexPath.row].categoryCode)"
        
        cell.labelBarcode.text = "Barcode: \(_listModel[indexPath.row].barcode)"
        let labelPrice = numberFormatter.string(from: NSNumber(value: _listModel[indexPath.row].price))
        cell.labelPrice.text = "\(labelPrice!)"
       
        if _listModel[indexPath.row].quantity > 0{
            cell.txtValue.text = "\(_listModel[indexPath.row].quantity)"
        }
        else{
            cell.txtValue.text = "1"
            _listModel[indexPath.row].quantity = 1
        }
        let total = Double(exactly: _listModel[indexPath.row].quantity)! * _listModel[indexPath.row].price
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let labelTotalPrice = numberFormatter.string(from: NSNumber(value: total))
        cell.labelTotalPrice.text = "x\(_listModel[indexPath.row].quantity) = \(labelTotalPrice!)"
        cell.txtValue.addTarget(self, action: #selector(CreateSellOutViewController.updateValue(_:)), for: UIControl.Event.editingChanged)
        cell.txtModel.addTarget(self, action: #selector(CreateSellOutViewController.updateModel(_:)), for: UIControl.Event.editingChanged)
        cell.txtModel.tag = indexPath.row
        cell.txtValue.tag = indexPath.row
        cell._delegate = self
        cell._delegateDisplay = self
        if _listModel[indexPath.row].isScan == 0 {
            cell.labelModel.text = "\(indexPath.row + 1). \(_listModel[indexPath.row].model)"
            cell.txtModel.isHidden = true
            cell.viewSpace.isHidden = false
            cell.labelTotalPrice.isHidden = false
            cell.labelCate.isHidden = false
            cell.labelPrice.isHidden = false
            cell.heightView.constant = 0
            cell.heightViewModel.constant = 88
            cell.collecView.isHidden = true
            cell.imgPhoto.isHidden = true
            cell.labelModel.isHidden = false
        }else{
            cell.labelModel.text = "\(indexPath.row + 1)."
          //  cell.labelModel.isHidden = true
            cell.txtModel.isHidden = false
            cell.viewSpace.isHidden = true
            cell.labelTotalPrice.isHidden = true
            cell.labelCate.isHidden = true
            cell.labelPrice.isHidden = true
            cell.collecView.isHidden = false
            cell.imgPhoto.isHidden = false
            cell.heightView.constant = 87
            cell.heightViewModel.constant = 50
            cell._imageList = _listPhoto.filter{$0.productguid == _listModel[indexPath.row].guid}
           // cell._imageList = _imageListController.GetListSellOut(_listModel[indexPath.row].guid)!
            if (cell._imageList.count) > 0 {
                cell.updateUI()
            }
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
}
extension CreateSellOutViewController: delegateImageDisplay{
    func takephoto(for cell: cellSellout) {
        guard let indexPath = myTable.indexPath(for: cell) else {
            return
        }
       
        _indexPath = indexPath.row
        camera = Camera(view: self, comment: "", imgType: "", employeeCode: "", latitude: 0, longitude: 0)
        camera.delegate = self
        camera.startCamera()
    }
    
    
}
extension CreateSellOutViewController: cameraProtocol{
    func ditReceiveImageUrl(imgUrl: String, imgName: String, imgData: Data, imgType: String, comment: String, latitude: Double, longitude: Double) {
        photo = ImageListModel()
        photo.urlimage = imgUrl
        photo.id = 0
        photo.shopId = _shopId!
        photo.empId = (_login?.employeeId)!
        photo.createddate = Int64(Date().millisecondsSince1970)
        photo.reportdate = Date().toIntShortDate()
        photo.productguid = _listModel[_indexPath].guid
        photo.model = _listModel[_indexPath].model
        photo.barcode = _listModel[_indexPath].barcode
        if _type == "STOCK" {
            photo.imageType = (_dataOfflineController.ByObjectName("IMAGETYPE", objectName: "STOCK")?.objectId)!
        }
        else{
            photo.imageType = (_dataOfflineController.ByObjectName("IMAGETYPE", objectName: "PRODUCT")?.objectId)!
        }
        photo.changed = 0
        self._listPhoto.append(self.photo)
         self.myTable.reloadData()
//        _imageListController.Insert(photo) { (success) in
//            if success! {
//                self._listPhoto.append(self.photo)
//                self.myTable.reloadData()
//            }
//        }
    }
}

extension CreateSellOutViewController: scanBarcodeDelegate{
    func getBarCode(_ barcode: String) {
       
        let product = _dataOfflineController.GetProductByBarCode(barcode)
        if let data = product {
            _listModel.append(data)
        }
        else{
            var model = ProductModel()
            model.barcode = barcode
            model.isScan = 1
            model.guid = UUID().uuidString
            _listModel.append(model)
        }
        heightTable.constant = heightTable.constant + 150
        myTable.reloadData()
    }
}

extension CreateSellOutViewController: delegateSelectModel{
    func get(_ listModel: [ProductModel]) {
        if listModel != nil && listModel.count > 0 {
            //var arrayMap: Array = listModel.map(){$0.model}
            //var joinedString: String  = arrayMap.joined(separator: ",")
            ////_model = joinedString
           // self._listModel = listModel
            checkListModel(listModel)
          // heightTable.constant = CGFloat(self._listModel.count * 100)
            myTable.reloadData()
        }
    }
    func checkListModel(_ list: [ProductModel]?){
        var i = 0
        for item in self._listModel {
            let model = list!.filter{$0.productId == item.productId}.first
            if model == nil && item.isScan == 0 {
                self._listModel.remove(at: i)
                heightTable.constant = heightTable.constant - 100
                continue
            }
            i = i + 1
        }
        for item in list! {
            let model = self._listModel.filter{$0.productId == item.productId}.first
            if model == nil {
                self._listModel.append(item)
                heightTable.constant = heightTable.constant + 100
            }
        }
    
    }
}
extension CreateSellOutViewController: delegateDisplay{
    func cal(for cell: cellSellout, size: Int) {
        guard let indexPath = myTable.indexPath(for: cell) else {
            return
        }
        self._indexPath = indexPath.row
        let quantity = _listModel[_indexPath].quantity + size
        if quantity < 0 {
            Function.Message("Info", message: "The number must be greater than or equal to 0")
            return
        }
        
        //let total = Double(exactly: _listModel[indexPath.row].quantity)! * _listModel[indexPath.row].price
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
         let total = Double(exactly: quantity)! * _listModel[_indexPath].price
        let labelTotalPrice = numberFormatter.string(from: NSNumber(value: total))
        cell.labelTotalPrice.text = "x\(quantity) = \(labelTotalPrice!)"
        _listModel[_indexPath].quantity = quantity
        cell.txtValue.text = "\(quantity)"
       // _displayController.save(arrCategory![_indexPath],type: "CATE")
    }
    func remove(for cell: cellSellout) {
        guard let indexPath = myTable.indexPath(for: cell) else {
            return
        }
        self._indexPath = indexPath.row
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có xoá model này", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            if self._listModel[self._indexPath].isScan == 1{
                self.heightTable.constant = self.heightTable.constant - 150
            }
            else{
                self.heightTable.constant = self.heightTable.constant - 100
            }
            self._listModel.remove(at: self._indexPath)
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
extension CreateSellOutViewController: delegateSelectSupplierData{
    func get(_ object: SupplierModel) {
        txtSupplier.text = "\(object.supplierCode),\(object.supplierName)"
        _supplierId = object.supplierId
    }
}
