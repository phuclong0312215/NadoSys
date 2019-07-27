//
//  CreateCollectViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/17/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegateRefeshCollectData {
    func refresh()
}
class CreateCollectViewController: UIViewController {

    var _listBrand = [ObjectDataModel]()
    var _listCate = [ObjectDataModel]()
    var _listType = [ObjectDataModel]()
    var _listTitle = [ObjectDataModel]()
    var _brandId: Int = 0
    var _typeId: Int = 0
    var _titleId: Int = 0
    var _delegate: delegateRefeshCollectData?
    @IBOutlet weak var txtDes: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtBrand: UITextField!
    @IBOutlet weak var txtCate: UITextField!
    @IBOutlet weak var txtModel: UITextField!
   
    @IBOutlet weak var txtGift: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var viewModel: UIView!
    @IBOutlet weak var viewCate: UIView!
    @IBOutlet weak var viewBrand: UIView!
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var viewTitle: UIView!
    var _dataOfflineController: IDataOffline!
    var _promotionController: IPromotion!
    var _dataOnlineController: IDataOnline!
    var gestureModel: UITapGestureRecognizer!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    override func viewDidLoad() {
        super.viewDidLoad()
       // setLayout()
        setEventView()
        initData()
        // Do any additional setup after loading the view.
    }
    
    func setEventView(){
        gestureModel = UITapGestureRecognizer(target: self, action:  #selector(self.getModel))
       // self.viewModel.addGestureRecognizer(gestureModel)
        let gestureBrand = UITapGestureRecognizer(target: self, action:  #selector(self.getBrand))
        self.viewBrand.addGestureRecognizer(gestureBrand)
        let gestureCate = UITapGestureRecognizer(target: self, action:  #selector(self.getCate))
        self.viewCate.addGestureRecognizer(gestureCate)
        let gestureType = UITapGestureRecognizer(target: self, action:  #selector(self.getType))
        self.viewType.addGestureRecognizer(gestureType)
        let gestureTitle = UITapGestureRecognizer(target: self, action:  #selector(self.getTitle))
        self.viewTitle.addGestureRecognizer(gestureTitle)
    }
    
    func initData(){
        let queue = DispatchQueue(label: "initObjectData")
        queue.async {
            self._listTitle = self._dataOfflineController.GetListObjectDatas("COLLECT_DATA_TITLE")!
            self._listBrand = self._dataOfflineController.GetListObjectDatas("Compertitor")!
            self._listType = self._dataOfflineController.GetListObjectDatas("PromotionType")!
            let tempCategory = self._dataOfflineController.GetCategory()
            self.getCategory(tempCategory!)
        }
    }
    
    func getCategory(_ list: [ProductModel]){
        var i: Int = 1
        for item in list {
            let model = ObjectDataModel()
            model.objectId = i
            model.objectName = item.categoryCode
            model.objectType = "CATEGORY"
            _listCate.append(model)
            i = i + 1
        }
    }
    
    @objc func getModel(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmModelList") as! ModelListViewController
        controller._strModel = txtModel.text!
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
        
        //pushViewController(withIdentifier: "frmModelList")
    }
    @objc func getTitle(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmObjectDataList") as! ObjectDataListViewController
        controller._objectName = txtTitle.text!
        controller._listObjs = _listTitle
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
        
        //pushViewController(withIdentifier: "frmModelList")
    }
    @objc func getBrand(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmObjectDataList") as! ObjectDataListViewController
        controller._objectName = txtBrand.text!
        controller._listObjs = _listBrand
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
        
        //pushViewController(withIdentifier: "frmModelList")
    }
    @objc func getCate(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmObjectDataList") as! ObjectDataListViewController
        controller._objectName = txtCate.text!
        controller._listObjs = _listCate
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
    }
    @objc func getType(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmObjectDataList") as! ObjectDataListViewController
        controller._objectName = txtType.text!
        controller._listObjs = _listType
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
    }
    
    func setLayout(){
        viewModel.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        viewCate.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        viewBrand.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        viewType.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        viewTitle.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        
    }

    func validate() -> Bool {
        if txtTitle.text == "" {
            Function.Message("Thông báo", message: "Bạn chưa nhập tên chương trình.")
            return false
        }
        if txtType.text == "" {
            Function.Message("Thông báo", message: "Bạn chưa chọn loại.")
            return false
        }
        if txtBrand.text == "" {
            Function.Message("Thông báo", message: "Bạn chưa chọn brand.")
            return false
        }
        return true
    }
    
    func toJson(_ item: PromotionModel) -> [Dictionary<String, AnyObject>] {
        var promotionResults: [Dictionary<String, AnyObject>] = []
       
        let dictS  : [String : AnyObject] = [
            "Id": 0 as AnyObject,
            "EmployeeId": item.employeeId as AnyObject,
            "ShopId": item.shopId as AnyObject,
            "ReportDate": item.reportDate as AnyObject,
            "CreatedDate": item.createdDate as AnyObject,
            "Brand": item.brand as AnyObject,
            "Model": item.model as AnyObject,
            "PromotionType": item.promotionType as AnyObject,
            "PromotionName": item.promotionName as AnyObject,
            "Category": item.category as AnyObject,
            "Decription": item.des as AnyObject,
            "Guid": item.guid as AnyObject,
            "Price": item.price as AnyObject,
            "Gift": item.gift as AnyObject,
            "TitleId": item.titleId as AnyObject
            
        ]
        promotionResults.append(dictS )
        
        return promotionResults
    }
    
    @IBAction func save(_ sender: Any) {
        if validate(){
            let promotion = PromotionModel()
            promotion.promotionType = _typeId
            promotion.employeeId = (_login?.employeeId)!
            promotion.shopId = _shopId!
            promotion.promotionName = txtTitle.text!
            promotion.createdDate = Date().toLongTimeString()
            promotion.reportDate = Date().toShortTimeString()
            promotion.des = txtDes.text!
            promotion.guid = UUID().uuidString
            promotion.model = txtModel.text!
            promotion.category = txtCate.text!
            promotion.brand = _brandId
            promotion.brandName = txtBrand.text!
            promotion.titleId = _titleId
            promotion.gift = txtGift.text!
            promotion.price = Double(txtPrice.text!)!
            promotion.changed = 0
            promotion.id = 0
            _promotionController.InsertPromotion(promotion)
            SVProgressHUD.show()
            _dataOnlineController.SaveInfo(Function.getJson(toJson(promotion)), url: URLs.URL_COLLECT_SAVEDATA) { (data, error) in
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
extension CreateCollectViewController: delegateSelectModel{
    func get(_ listModel: [ProductModel]) {
        if listModel != nil && listModel.count > 0 {
            var arrayMap: Array = listModel.map(){$0.model}
            var joinedString: String  = arrayMap.joined(separator: ",")
            txtModel.text = joinedString
        }
    }
    
    
}
extension CreateCollectViewController: delegateSelectObjectData{
    func get(_ object: ObjectDataModel) {
        if object.objectType == "Compertitor"{
            txtBrand.text = object.objectName
            if txtBrand.text != "Aqua"{
                viewModel.removeGestureRecognizer(gestureModel)
                txtModel.isEnabled = true
            }
            else{
                txtModel.isEnabled = false
               self.viewModel.addGestureRecognizer(gestureModel)
            }
            txtModel.text = ""
            _brandId = object.objectId
        }
        else if object.objectType == "PromotionType"{
            txtType.text = object.objectName
            _typeId = object.objectId
        }
        else if object.objectType == "CATEGORY"{
            txtCate.text = object.objectName
        }
        else if object.objectType == "COLLECT_DATA_TITLE"{
            txtTitle.text = object.objectName
            _titleId = object.objectId
        }
    }
    
    
}
