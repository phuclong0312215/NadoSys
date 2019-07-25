//
//  CollectDataViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/17/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class CollectDataViewController: UIViewController {

    @IBOutlet weak var btnAdd: UIButton!
    var _guid: String = ""
    var _promotionController: IPromotion!
    var _dataOnlineController: IDataOnline!
    var camera: Camera!
    var _listPromotion : [PromotionModel]? = []
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _shopName = Preferences.get(key: "SHOPNAME")
    var photo = PromotionImageModel()
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "ic_add_white.png")
        var imageView = UIImageView(frame: CGRect(x: 2, y: 2, width: 25, height: 25))
        imageView.image = image
        btnAdd.addSubview(imageView)
        myTable.delegate = self
        myTable.dataSource = self
        let queue = DispatchQueue(label: "com.collecData")
        queue.async {
            self.loadData()
        }
        addRightButton()
        // Do any additional setup after loading the view.
    }
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title:"Collect Data", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title:"NDS", style:.plain, target:nil, action:nil)
    }
    func loadData(){
        _listPromotion = _promotionController.GetList(_shopId!, reportDate: Date().toShortTimeString(), empId: (_login?.employeeId)!)
        if _listPromotion != nil && (_listPromotion?.count)! > 0{
            DispatchQueue.main.async {
                self.myTable.reloadData()
            }
        }
    }
    
    @IBAction func newData(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmCreateCollect") as! CreateCollectViewController
        controller._delegate = self
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
        //pushViewController(withIdentifier: "frmCreateCollect")
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
extension CollectDataViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(_listPromotion == nil){
            return 0
        }
        return _listPromotion!.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCollectData", for: indexPath) as! cellAquaImageDisplay
        cell.labelBrand.text = "\(_listPromotion![indexPath.row].brandName)"
        cell.labelCategory.text = "\(_listPromotion![indexPath.row].category)"
        cell.labelModel.text = "\(_listPromotion![indexPath.row].model)"
        cell.labelTitle.text = "\(_listPromotion![indexPath.row].promotionName)"
        cell.viewLayout.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        cell._imageList = _promotionController.GetImageList(_shopId!, reportDate: Date().toShortTimeString(), empId: (_login?.employeeId)!, guid: _listPromotion![indexPath.row].guid)
        if (cell._imageList?.count)! > 0{
            cell.updateUI()
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell._delegate = self
        return cell
        
    }
}
extension CollectDataViewController: delegateImageDisplay{
    func takephoto(for cell: cellAquaImageDisplay) {
        guard let indexPath = myTable.indexPath(for: cell) else {
            return
        }
        _guid = _listPromotion![indexPath.row].guid
        camera = Camera(view: self, comment: "", imgType: "", employeeCode: "", latitude: 0, longitude: 0)
        camera.delegate = self
        camera.startCamera()
    }
    
    
}
extension CollectDataViewController: cameraProtocol{
    func toJson(_ item: PromotionImageModel) -> Data {
        var jsonString = ""
        var results: [Dictionary<String, AnyObject>] = []
        let json  : [String : AnyObject] = [
            "Id": 0 as AnyObject,
            "EmployeeId": item.employeeId as AnyObject,
            "ShopId": item.shopId as AnyObject,
            "ReportDate": item.reportDate as AnyObject,
            "CreatedDate": item.createdDate as AnyObject,
            "Timing": item.createdDate as AnyObject,
            "Guid": item.guid as AnyObject,
            "ShopName": item.shopName as AnyObject
        ]
        results.append(json)
        do{
            let data = try JSONSerialization.data(withJSONObject: results, options:.prettyPrinted)
            jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            
        }
        catch let error as NSError{
            print(error.description)
        }
        print(jsonString)
        return jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)!
    }
    func ditReceiveImageUrl(imgUrl: String, imgName: String, imgData: Data, imgType: String, comment: String, latitude: Double, longitude: Double) {
        photo = PromotionImageModel()
        photo.shopName = _shopName
        photo.urlImage = imgUrl
        photo.id = 0
        photo.shopId = _shopId!
        photo.employeeId = (_login?.employeeId)!
        photo.createdDate = Date().toLongTimeString()
        photo.reportDate = Date().toShortTimeString()
        photo.guid = _guid
        photo.changed = 0
        _promotionController.InsertPromotionImage(photo) { (success) in
            if success! {
                var arrData = [Data]()
                let image = UIImage(contentsOfFile: Function.getPath(self.photo.urlImage))
                arrData.append(image!.pngData()!)
                arrData.append(self.toJson(self.photo))
                self._dataOnlineController.UploadDisplay(URLs.URL_COLLECT_SAVEIMAGE, data: arrData, completionHandler: { (data, error) in
                    DispatchQueue.main.async {
                        if data != nil{
                            print(data)
                        }
                    }
                })
                self.myTable.reloadData()
            }
        }
    }
}

extension CollectDataViewController: delegateRefeshCollectData{
    func refresh() {
        loadData()
    }
}
