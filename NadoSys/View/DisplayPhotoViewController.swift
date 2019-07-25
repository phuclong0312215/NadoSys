//
//  DisplayPhotoViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/15/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class DisplayPhotoViewController: UIViewController {
    var camera: Camera!
    var _dataOfflineController: IDataOffline!
    var _dataOnlineController: IDataOnline!
    var _imageListController: IImageList!
    var _categorys: [ProductModel] = []
    var _competitorId: Int = 0
    var _categoryCode: String = ""
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _imageType: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        _categorys  = _dataOfflineController.GetCategory()!
        let item = ProductModel()
        item.categoryCode = "OVERVIEW"
        _categorys.insert(item, at: 0)
        _imageType = (_dataOfflineController.ByObjectName("IMAGETYPE", objectName: "DISPLAY")?.objectId)!
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var myTable: UITableView!
    

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
    
    @IBAction func save(_ sender: Any) {
        var count: Int = 0
        let images = self._imageListController.GetListUploads(self._competitorId, shopId: self._shopId!, reportDate: Date().toIntShortDate(), imageType: self._imageType, empId: (self._login?.employeeId)!)
        if images != nil && (images?.count)! > 0{
            SVProgressHUD.show()
            for item in images!{
                var arrData = [Data]()
                let image = UIImage(contentsOfFile: Function.getPath(item.urlimage))!
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DisplayPhotoViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(_categorys == nil){
            return 0
        }
        return _categorys.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 117
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAquaImage", for: indexPath) as! cellAquaImageDisplay
        cell._delegate = self
        cell.buttonCate.setRounded(radius: 6)
        cell.buttonCate.setTitle("\(_categorys[indexPath.row].categoryCode)", for: .normal)
        let objectName = _categorys[indexPath.row].categoryCode != "OVERVIEW" ? "DISPLAY" : _categorys[indexPath.row].categoryCode
        let imageType = (_dataOfflineController.ByObjectName("IMAGETYPE", objectName: objectName)?.objectId)!
        cell._imageList = _imageListController.GetLists(_competitorId, shopId: _shopId!, reportDate: Date().toIntShortDate(), imageType: imageType, empId: (_login?.employeeId)!,categoryCode: _categorys[indexPath.row].categoryCode)
        if (cell._imageList?.count)! > 0 {
           cell.updateUI()
        }
        return cell
        
    }
  
}
extension DisplayPhotoViewController: delegateImageDisplay{
    func takephoto(for cell: cellAquaImageDisplay) {
        guard let indexPath = myTable.indexPath(for: cell) else {
            return
        }
        _categoryCode = _categorys[indexPath.row].categoryCode
        camera = Camera(view: self, comment: "", imgType: "", employeeCode: "", latitude: 0, longitude: 0)
        camera.delegate = self
        camera.startCamera()
    }
    
    
}
extension DisplayPhotoViewController: cameraProtocol{
    func ditReceiveImageUrl(imgUrl: String, imgName: String, imgData: Data, imgType: String, comment: String, latitude: Double, longitude: Double) {
        let photo = ImageListModel()
        photo.urlimage = imgUrl
        let objectName = _categoryCode != "OVERVIEW" ? "DISPLAY" : _categoryCode
        photo.imageType = (_dataOfflineController.ByObjectName("IMAGETYPE", objectName: objectName)?.objectId)!
        photo.shopId = _shopId!
        photo.empId = (_login?.employeeId)!
        photo.competitorId = _competitorId
        photo.createddate = Int64(Date().millisecondsSince1970)
        photo.reportdate = Date().toIntShortDate()
        photo.categorycode = _categoryCode
        _imageListController.Insert(photo) { (success) in
            if success! {
                self.myTable.reloadData()
            }
        }
    }
}
