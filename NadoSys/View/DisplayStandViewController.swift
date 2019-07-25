//
//  DisplayStandViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/19/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class DisplayStandViewController: UIViewController {
    var _posmId: Int = 0
    @IBOutlet weak var btnAdd: UIButton!
    var _displayStandController: IDisplayStand!
    var _dataOnlineController: IDataOnline!
    var camera: Camera!
    var _listDisplayStand: [DisplayStandModel]? = []
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _shopName = Preferences.get(key: "SHOPNAME")
    var photo = DisplayStandImageModel()
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "ic_add_white.png")
        var imageView = UIImageView(frame: CGRect(x: 2, y: 2, width: 25, height: 25))
        imageView.image = image
        btnAdd.addSubview(imageView)
        myTable.delegate = self
        myTable.dataSource = self
        let queue = DispatchQueue(label: "com.displaystand")
        queue.async {
            self.loadData()
        }
        addRightButton()
        // Do any additional setup after loading the view.
    }
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title:"Display Stand/POSM", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title:"NDS", style:.plain, target:nil, action:nil)
    }
    
    @IBAction func scan(_ sender: Any) {
        
    }
    func loadData(){
        _listDisplayStand = _displayStandController.GetList(_shopId!, reportDate: Date().toShortTimeString(), empId: (_login?.employeeId)!)
        if _listDisplayStand != nil && (_listDisplayStand?.count)! > 0{
            DispatchQueue.main.async {
                self.myTable.reloadData()
            }
        }
    }
    
    @IBAction func new(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmPOSM") as! CreateDisplayStandViewController
        controller._delegate = self
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
extension DisplayStandViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(_listDisplayStand == nil){
            return 0
        }
        return _listDisplayStand!.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 189
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDisplayStand", for: indexPath) as! cellAquaImageDisplay
        cell.labelQty.text = "SL: \(_listDisplayStand![indexPath.row].qty)"
        cell.labelNote.text = "Note: \(_listDisplayStand![indexPath.row].note)"
        cell.labelStatus.text = "\(_listDisplayStand![indexPath.row].statusName)"
        cell.labelTitle.text = "\(_listDisplayStand![indexPath.row].posmName)"
        cell.labelBarcode.text = "\(_listDisplayStand![indexPath.row].barcode)"
        cell.viewLayout.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        cell._imageList = _displayStandController.GetImageList(_shopId!, reportDate: Date().toShortTimeString(),posmId: _listDisplayStand![indexPath.row].posmId, empId: (_login?.employeeId)!)
        if (cell._imageList?.count)! > 0{
            cell.updateUI()
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell._delegate = self
        return cell
        
    }
}
extension DisplayStandViewController: delegateImageDisplay{
    func takephoto(for cell: cellAquaImageDisplay) {
        guard let indexPath = myTable.indexPath(for: cell) else {
            return
        }
        _posmId = _listDisplayStand![indexPath.row].posmId
        camera = Camera(view: self, comment: "", imgType: "", employeeCode: "", latitude: 0, longitude: 0)
        camera.delegate = self
        camera.startCamera()
    }
    
    
}
extension DisplayStandViewController: cameraProtocol{
    func toJson(_ item: DisplayStandImageModel) -> Data {
        var jsonString = ""
        let json  : [String : AnyObject] = [
            "Id": 0 as AnyObject,
            "EmployeeId": item.employeeId as AnyObject,
            "ShopId": item.shopId as AnyObject,
            "ReportDate": item.reportDate as AnyObject,
            "CreatedDate": item.createdDate as AnyObject,
            "Timing": item.createdDate as AnyObject,
            "PosmId": item.posmId as AnyObject,
            "ShopName": item.shopName as AnyObject
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
        photo = DisplayStandImageModel()
        photo.shopName = _shopName
        photo.urlImage = imgUrl
        photo.id = 0
        photo.shopId = _shopId!
        photo.employeeId = (_login?.employeeId)!
        photo.createdDate = Date().toLongTimeString()
        photo.reportDate = Date().toShortTimeString()
        photo.posmId = _posmId
        photo.changed = 0
        _displayStandController.InsertStandImage(photo) { (success) in
            if success! {
                var arrData = [Data]()
                let image = UIImage(contentsOfFile: Function.getPath(self.photo.urlImage))
                arrData.append(image!.pngData()!)
                arrData.append(self.toJson(self.photo))
                self._dataOnlineController.UploadDisplay(URLs.URL_DISPLAYSTAND_SAVEIMAGE, data: arrData, completionHandler: { (data, error) in
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

extension DisplayStandViewController: delegateRefeshCollectData{
    func refresh() {
        loadData()
    }
}
