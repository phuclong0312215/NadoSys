//
//  EmployeeShopProfileViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/7/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
class EmployeeShopProfileViewController: UIViewController {

    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    @IBOutlet weak var tableEmpAttan: UITableView!
    var _dataOnlineController: IDataOnline!
    @IBOutlet weak var tableDisplay: UITableView!
    @IBOutlet weak var labelWeek: UILabel!
    @IBOutlet weak var btnPS: UIButton!
    @IBOutlet weak var btnME: UIButton!
    @IBOutlet weak var btnLSR: UIButton!
    @IBOutlet weak var btnAll: UIButton!
    var _shop = ShopModel()
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var tableEmpAvg: UITableView!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelShopGrade: UILabel!
    @IBOutlet weak var labelContact: UILabel!
    @IBOutlet weak var labelShopSize: UILabel!
    @IBOutlet weak var labelChannel: UILabel!
    @IBOutlet weak var labelShopName: UILabel!
    @IBOutlet weak var labelShopCode: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShopInfo()

        // Do any additional setup after loading the view.
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
       // print(jsonData)
        labelContact.text = jsonData["contactName"].stringValue
        labelPhone.text = jsonData["contactPhone"].stringValue
        labelShopSize.text = jsonData["shopSize"].stringValue
        labelChannel.text = _shop.objectName
        labelShopGrade.text = _shop.grade
        labelShopCode.text = _shop.shopCode
        labelShopName.text = _shop.shopName
        labelAddress.text = _shop.address
        if _shop.latitude > 0 && _shop.longitude > 0 {
            let location = CLLocationCoordinate2D(latitude: _shop.latitude,longitude: _shop.longitude)
            zoom(location)
        }
        else{
            let address =  "" //\(txtHouseNumber.text!) \(txtStreet.text!) \(txtVilla.text!),\(txtWard.text!),\(txtProvince.text!),\(txtProvince.text!)"
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
