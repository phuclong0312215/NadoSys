//
//  DisplayItemViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/10/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class DisplayItemViewController: BaseViewController {
    
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    var _indexPath = 0
    @IBOutlet weak var myTableData: UITableView!
    @IBOutlet weak var myTableImage: UITableView!
    var pageIndex: Int! = 0
    var lbTitle: String = ""
    var _displayController: IDisplay!
    var _dataOfflineController: IDataOffline!
    var _imageListController: IImageList!
    var _dataOnlineController: IDataOnline!
    var camera: Camera!
    @IBOutlet weak var lableCompetitor: UILabel!
    var arrCategory : [DisplayModel]? = []
    var _categoryCode: String = ""
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _competitorId: Int = 0
    var _imageType: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        lableCompetitor.text = lbTitle
        _imageType = (_dataOfflineController.ByObjectName("IMAGETYPE", objectName: "DISPLAY")?.objectId)!
        myTableData.delegate = self
        myTableData.dataSource = self
        myTableImage.delegate = self
        myTableImage.dataSource = self
        heightTable.constant = CGFloat((arrCategory?.count)! * 45)
        // Do any additional setup after loading the view.
    }
    
    
    func toJson(_ lst: [DisplayModel]) -> [Dictionary<String, AnyObject>] {
        var displayResults: [Dictionary<String, AnyObject>] = []
        for item in lst{
            let dictS  : [String : AnyObject] = [
                "Id": 0 as AnyObject,
                "ProductId": item.productId as AnyObject,
                "EmployeeId": item.employeeId as AnyObject,
                "ShopId": item.shopId as AnyObject,
                "ReportDate": Date().toShortTimeString() as AnyObject,
                "Timing": Date().toLongTimeString() as AnyObject,
                "CategoryCode": item.categoryCode as AnyObject,
                "CompetitorId": item.competitorId as AnyObject,
                "Qty": item.qty as AnyObject
            ]
            displayResults.append(dictS )
        }
        return displayResults
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
            "ShopName": "" as AnyObject,
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
    
    func getPath(_ path: String) -> String{
        return (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(path)
    }
    
    @IBAction func save(_ sender: UIButton) {
        var count: Int = 0
        SVProgressHUD.show()
        _dataOnlineController.SaveInfo(Function.getJson(toJson(arrCategory!)), url: URLs.URL_DISPLAY_SAVEDATA) { (data, error) in
            if data != nil {
                let images = self._imageListController.GetListUploads(self._competitorId, shopId: self._shopId!, reportDate: Date().toIntShortDate(), imageType: self._imageType, empId: (self._login?.employeeId)!)
                if images != nil && (images?.count)! > 0{
                    for item in images!{
                        var arrData = [Data]()
                        let image = UIImage(contentsOfFile: self.getPath(item.urlimage))!
                        arrData.append(image.pngData()!)
                        arrData.append(self.toJsonImage(item))
                        self._dataOnlineController.UploadDisplay(URLs.URL_DISPLAY_SAVEIMAGE, data: arrData, completionHandler: { (data, error) in
                            DispatchQueue.main.async {
                                if data != nil{
                                    count = count + 1
                                    if count == images?.count{
                                         SVProgressHUD.dismiss()
                                        Function.Message("Info", message: "Save successfully")
                                    }
                                }
                            }
                        })
                    }
                }
                else{
                    SVProgressHUD.dismiss()
                }
            }
            else{
                SVProgressHUD.dismiss()
            }
        }
    }
    @objc func updateValue(_ textField: UITextField){
        let row = textField.tag
        var quantity = 0
        if(textField.text != ""){
            quantity = Int(textField.text!)!
        }
        if quantity < 0 {
            Function.Message("Info", message: "The number must be greater than or equal to 0")
            return
        }
        arrCategory![row].qty = quantity
        _displayController.save(arrCategory![row],type: "CATE")
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
extension DisplayItemViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(arrCategory == nil){
            return 0
        }
        return arrCategory!.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == myTableData){
            return 45
        }
        else{
            return 113
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == myTableData{
              let cell = tableView.dequeueReusableCell(withIdentifier: "cellCateDisplay", for: indexPath) as! cellCateDisplay
            cell.delegate = self
            cell.labelCate.text = "\(indexPath.row + 1) \(arrCategory![indexPath.row].categoryCode)"
            cell.labelCate.setBorder(radius: 6)
            cell.txtValue.text = "\(arrCategory![indexPath.row].qty)"
            cell.txtValue.tag = indexPath.row
            cell.txtValue.addTarget(self, action: #selector(DisplayItemViewController.updateValue(_:)), for: UIControl.Event.editingChanged)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellAquaImage", for: indexPath) as! cellAquaImageDisplay
            cell._delegate = self
            cell.buttonCate.setBorder(radius: 6)
            cell.buttonCate.setTitle("\(arrCategory![indexPath.row].categoryCode)", for: .normal)
            cell._imageList = _imageListController.GetLists(_competitorId, shopId: _shopId!, reportDate: Date().toIntShortDate(), imageType: _imageType, empId: (_login?.employeeId)!,categoryCode: arrCategory![indexPath.row].categoryCode)
            if (cell._imageList?.count)! > 0 {
                cell.updateUI()
            }
             cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
       
       
    }
}

extension DisplayItemViewController: delegateCateDisplay{
    func cal(for cell: cellCateDisplay, size: Int) {
        guard let indexPath = myTableData.indexPath(for: cell) else {
            return
        }
        self._indexPath = indexPath.row
        let quantity = arrCategory![_indexPath].qty + size
        if quantity < 0 {
            Function.Message("Info", message: "The number must be greater than or equal to 0")
            return
        }
        arrCategory![_indexPath].qty = quantity
        cell.txtValue.text = "\(quantity)"
        _displayController.save(arrCategory![_indexPath],type: "CATE")
    }
    
    
}
extension DisplayItemViewController: delegateImageDisplay{
    func takephoto(for cell: cellAquaImageDisplay) {
        guard let indexPath = myTableImage.indexPath(for: cell) else {
            return
        }
        _categoryCode = arrCategory![indexPath.row].categoryCode
        camera = Camera(view: self, comment: "", imgType: "", employeeCode: "", latitude: 0, longitude: 0)
        camera.delegate = self
        camera.startCamera()
    }
    
    
}
extension DisplayItemViewController: cameraProtocol{
    func ditReceiveImageUrl(imgUrl: String, imgName: String, imgData: Data, imgType: String, comment: String, latitude: Double, longitude: Double) {
        let photo = ImageListModel()
        photo.urlimage = imgUrl
        photo.imageType = _imageType
        photo.shopId = _shopId!
        photo.empId = (_login?.employeeId)!
        photo.competitorId = _competitorId
        photo.createddate = Int64(Date().millisecondsSince1970)
        photo.reportdate = Date().toIntShortDate()
        photo.categorycode = _categoryCode
        _imageListController.Insert(photo) { (success) in
            if success! {
                self.myTableImage.reloadData()
            }
        }
    }
}
