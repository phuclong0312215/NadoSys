//
//  POSMImageViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/22/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import Toast_Swift
class POSMImageViewController: UIViewController {
    var _imageList: [ImageListModel]?
    var camera: Camera!
    var _dataOfflineController: IDataOffline!
    var _dataOnlineController: IDataOnline!
    var _imageListController: IImageList!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _imageType: Int = 0
    var _date = Date()
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectView.delegate = self
        collectView.dataSource = self
        _imageType = (_dataOfflineController.ByObjectName("IMAGETYPE", objectName: "POSM")?.objectId)!
        loadData()
        addRightButton()
        labelTitle.text = "Hình ảnh triển khai POSM ngày \(_date.toShortTimeString())"
        // Do any additional setup after loading the view.
    }
    
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Hình ảnh triển khai POSM", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title: "NDS", style:.plain, target:nil, action:nil)
    }
    
    
    func loadData(){
        _imageList = _imageListController.GetListUploads(0, shopId: _shopId!, reportDate: _date.toIntShortDate(), imageType: _imageType, empId: (_login?.employeeId)!)
        if (_imageList?.count)! > 0 {
            updateUI()
        }
    }
    
    @IBAction func takeImage(_ sender: Any) {
        camera = Camera(view: self, comment: "", imgType: "", employeeCode: "", latitude: 0, longitude: 0)
        camera.delegate = self
        camera.startCamera()
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
extension POSMImageViewController: cameraProtocol{
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
    
    
    func ditReceiveImageUrl(imgUrl: String, imgName: String, imgData: Data, imgType: String, comment: String, latitude: Double, longitude: Double) {
        let photo = ImageListModel()
        photo.urlimage = imgUrl
        photo.imageType = _imageType
        photo.shopId = _shopId!
        photo.empId = (_login?.employeeId)!
        photo.competitorId = 0
        photo.createddate = Int64(Date().millisecondsSince1970)
        photo.reportdate = Date().toIntShortDate()
       // photo.categorycode = _categoryCode
        var arrData = [Data]()
        let image = UIImage(contentsOfFile: Function.getPath(imgUrl))!
        arrData.append(image.pngData()!)
        arrData.append(self.toJsonImage(photo))
        SVProgressHUD.show()
        self._dataOnlineController.UploadDisplay(URLs.URL_DISPLAY_SAVEIMAGE, data: arrData, completionHandler: { (data, error) in
            DispatchQueue.main.async {
                if data != nil{
                    SVProgressHUD.dismiss()
                    self._imageListController.Insert(photo) { (success) in
                        if success! {
                            self._imageList?.append(photo)
                            self.collectView.reloadData()
                        }
                    }
                    self.view.makeToast("Lưu thành công.")
                }
            }
        })
        
    }
}
extension POSMImageViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func updateUI(){
        collectView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (_imageList!.count)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectView.dequeueReusableCell(withReuseIdentifier: "collectImageCell", for: indexPath) as! collectImageCell
        fetchImage(urlImage: _imageList![indexPath.row].urlimage, imgView: cell.imageView )
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func fetchImage(urlImage: String,imgView: UIImageView) {
        let imagePAth = Function.getDirectoryPath() + "/\(urlImage)"
        imgView.image = UIImage(contentsOfFile: imagePAth)
    }
}


