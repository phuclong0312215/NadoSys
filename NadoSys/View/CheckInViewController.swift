//
//  CheckInViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/10/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import CoreLocation
class CheckInViewController: UIViewController,cameraProtocol,CLLocationManagerDelegate {
    func toJson(_ item: AttandanceModel) -> Data {
        var jsonString = ""
        let json  : [String : AnyObject] = [
            "EmployeeId": item.empid as AnyObject,
            "ShopId": item.shopid as AnyObject,
            "aType": item.atype as AnyObject,
            "AttendantDate2": item.attendancedate as AnyObject,
            "AttendantTime": item.createddate as AnyObject,
            "Latitude": item.latitude as AnyObject,
            "Longitude": item.longitude as AnyObject,
            "Accuracy": item.accuracy as AnyObject,
            "ShopName": item.shopname as AnyObject,
            "LogFrom": "IOS" as AnyObject,
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
        let model = AttandanceModel()
        model.atype = imgType
        model.photo = imgUrl
        model.shopid = _shopId!
        model.shopname = _shopName
        model.empid = (_login?.employeeId)!
        model.guidid = UUID().uuidString
        model.createddate = Date().toLongTimeString()
        model.attendancedate = Date().toShortTimeString()
        model.blockstatus = 0
        model.isdeleted = 0
        model.ischange = 0
        model.accuracy = self.LOCATIONS.horizontalAccuracy
        model.latitude = self.LOCATIONS.coordinate.latitude
        model.longitude = self.LOCATIONS.coordinate.longitude
        _attandanceController.InsertAttandance(model) { (success) in
            if success! {
                self.imgCheck.isUserInteractionEnabled = false
                SVProgressHUD.show()
                var arrData = [Data]()
                let image = UIImage(contentsOfFile: Function.getPath(model.photo))
                arrData.append(image!.pngData()!)
                arrData.append(self.toJson(model))
                self._dataOnlineController.UploadDisplay(URLs.URL_ATTANDANCE_SAVE, data: arrData, completionHandler: { (data, error) in
                    DispatchQueue.main.async {
                        if data != nil{
                            let path = Function.getPath((model.photo))
                            self.imgCheck.setImage(UIImage(contentsOfFile: path), for: .normal)
                        }
                        SVProgressHUD.dismiss()
                    }
                })
            }
        }
        
    }
    

    @IBOutlet weak var imgCheck: UIButton!
    @IBOutlet weak var labelAttendance: UILabel!
    var camera: Camera!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    var _shopName = Preferences.get(key: "SHOPNAME")
    var _type = Preferences.get(key: "CHECKTYPE")
    @IBOutlet weak var labelFieldOfficer: UILabel!
    @IBOutlet weak var labelTimeVisit: UILabel!
    @IBOutlet weak var labelAccuracy: UILabel!
    @IBOutlet weak var labelLongitude: UILabel!
    @IBOutlet weak var labelLatitude: UILabel!
    var _attandanceController: IAttandance!
    var _dataOnlineController: IDataOnline!
    //location manager
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0  // Movement threshold for new events
        //  _locationManager.allowsBackgroundLocationUpdates = true // allow in background
        
        return _locationManager
    }()
    
    var LOCATIONS:CLLocation=CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                 print("GPS No Access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
           Function.Message("Info", message: "Location services are not enabled. Please enabled GPS")
        }
        if _type == "IN"{
            labelAttendance.text = "Giờ vào"
        }
        else{
            labelAttendance.text = "Giờ ra"
        }
        setNavigationBar()
        if let username = _login?.userName{
            labelFieldOfficer.text = "\(username)"
        }
        labelTimeVisit.text = Date().toLongTimeStringUpload()
        let attandance = _attandanceController.GetByType(_shopId!, empId: (_login?.employeeId)!, attandanceDate: Date().toShortTimeString(), aType: _type)
        if attandance != nil {
            let path = Function.getPath((attandance?.photo)!)
            imgCheck.setImage(UIImage(contentsOfFile: path), for: .normal)
            imgCheck.isUserInteractionEnabled = false
            if _type == "IN"{
                labelAttendance.text = "Giờ vào: "  + (attandance?.createddate.split(separator: " ")[1])!
            }
            else{
                labelAttendance.text = "Giờ ra: "  + (attandance?.createddate.split(separator: " ")[1])!
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CheckIn(_ sender: Any) {
        camera = Camera(view: self, comment: "", imgType: _type, employeeCode: (_login?.userName)!, latitude: 0, longitude: 0)
        camera.delegate = self
        camera.startCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //allow location use
        locationManager.requestAlwaysAuthorization()
        
        print("did load")
        print(locationManager)
        
        //get current user location for startup
        // if CLLocationManager.locationServicesEnabled() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Couldn't get your location")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.LOCATIONS = locations.last! as CLLocation
        print(self.LOCATIONS.coordinate.latitude)
        print(self.LOCATIONS.coordinate.longitude)
        labelAccuracy.text = "\(self.LOCATIONS.horizontalAccuracy)"
        labelLatitude.text = "\(self.LOCATIONS.coordinate.latitude)"
        labelLongitude.text = "\(self.LOCATIONS.coordinate.longitude)"
         labelTimeVisit.text = Date().toLongTimeStringUpload()
    }
    
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title:_type == "IN" ? "Check In/Chấm công vào" : "Check Out/Chấm công ra", style:.plain, target:nil, action:nil)
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
