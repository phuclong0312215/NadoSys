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

    var constHeightAtt = 0
    @IBOutlet weak var viewEmpAvg: UIView!
    @IBOutlet weak var labelEmpAvg: UILabel!
    @IBOutlet weak var viewDisplayFix: UIView!
    @IBOutlet weak var labelDisplayFix: UILabel!
    @IBOutlet weak var heightDisplayFix: NSLayoutConstraint!
    @IBOutlet weak var viewEmpAtt: UIView!
    @IBOutlet weak var labelEmpAtt: UILabel!
    @IBOutlet weak var heightEmpAtt: NSLayoutConstraint!
    @IBOutlet weak var _myTable: UITableView!
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
    var _lstReportEmpAtt = [EmployeeAttModel]()
    var _lstReportEmpAttFilter = [EmployeeAttModel]()
    var _lstReportDisplayFix = [DisplayFixModel]()
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
        _myTable.delegate = self
        _myTable.dataSource = self
        tableDisplay.delegate = self
        tableDisplay.dataSource = self
        loadShopInfo()
        loadEmployeeAtt()
        loadDisplayFix()
        viewEmpAvg.setBorder(radius: 4, color: UIColor(netHex: 0x1966a7))
        labelEmpAvg.setBorder(radius: 6, color: UIColor(netHex: 0x1966a7))
         viewEmpAtt.setBorder(radius: 4, color: UIColor(netHex: 0x1966a7))
         labelEmpAtt.setBorder(radius: 6, color: UIColor(netHex: 0x1966a7))
        viewDisplayFix.setBorder(radius: 4, color: UIColor(netHex: 0x1966a7))
        labelDisplayFix.setBorder(radius: 6, color: UIColor(netHex: 0x1966a7))
         labelWeek.text = "Week \(Date().week())/\(Date().year())"
        constHeightAtt = Int(heightEmpAtt.constant)
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
    
    func loadEmployeeAtt(){
        _dataOnlineController.GetReportEmployeeAttadance((_login?.employeeId)!, shopId: _shopId!, fromDate: (Date().startOfWeek?.toShortTimeString())!,toDate: (Date().endOfWeek?.toShortTimeString())!) { (data, error) in
            DispatchQueue.main.async {
                if data != nil{
                    self._lstReportEmpAtt = data!
                    self._lstReportEmpAttFilter = data!
                    self._myTable.reloadData()
                    self.heightEmpAtt.constant = CGFloat(self.constHeightAtt) + CGFloat(191 * ((data?.count)! - 1))
                }
            }
        }
    }
    
    func loadDisplayFix(){
        _dataOnlineController.GetReportDisplayFix((_login?.employeeId)!, shopId: _shopId!, fromDate: (Date().startOfWeek?.toShortTimeString())!,toDate: (Date().endOfWeek?.toShortTimeString())!) { (data, error) in
            DispatchQueue.main.async {
                if data != nil{
                    self._lstReportDisplayFix = data!
                    self.tableDisplay.reloadData()
                    self.heightDisplayFix.constant = self.heightDisplayFix.constant + CGFloat(44 * ((data?.count)! - 1))
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

    @IBAction func btnPS(_ sender: Any) {
        _lstReportEmpAttFilter = _lstReportEmpAtt.filter{$0.position == "PS"}
        btnPS.setTitleColor(UIColor(netHex: 0x1966a7), for: .normal)
        btnME.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        btnLSR.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        btnAll.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        self.heightEmpAtt.constant = CGFloat(self.constHeightAtt) + CGFloat(191 * ((_lstReportEmpAttFilter.count) - 1))
        _myTable.reloadData()
    }
    @IBAction func btnME(_ sender: Any) {
        _lstReportEmpAttFilter = _lstReportEmpAtt.filter{$0.position == "ME"}
        btnPS.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        btnME.setTitleColor(UIColor(netHex: 0x1966a7), for: .normal)
        btnLSR.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        btnAll.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        self.heightEmpAtt.constant = CGFloat(self.constHeightAtt) + CGFloat(191 * ((_lstReportEmpAttFilter.count) - 1))
        _myTable.reloadData()
    }
    @IBAction func btnLSR(_ sender: Any) {
        _lstReportEmpAttFilter = _lstReportEmpAtt.filter{$0.position == "LSR"}
        btnPS.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        btnME.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        btnLSR.setTitleColor(UIColor(netHex: 0x1966a7), for: .normal)
        btnAll.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        self.heightEmpAtt.constant = CGFloat(self.constHeightAtt) + CGFloat(191 * ((_lstReportEmpAttFilter.count) - 1))
        _myTable.reloadData()
    }
    @IBAction func btnAll(_ sender: Any) {
        _lstReportEmpAttFilter = _lstReportEmpAtt
        btnPS.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        btnME.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        btnLSR.setTitleColor(UIColor(netHex: 0xD6D6D6), for: .normal)
        btnAll.setTitleColor(UIColor(netHex: 0x1966a7), for: .normal)
        self.heightEmpAtt.constant = CGFloat(self.constHeightAtt) + CGFloat(191 * ((_lstReportEmpAttFilter.count) - 1))
        _myTable.reloadData()
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
extension EmployeeShopProfileViewController: UITableViewDelegate,UITableViewDataSource{
    func updateTableView(_ tableView: UITableView){
        tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableDisplay{
            return _lstReportDisplayFix.count
        }
        return _lstReportEmpAttFilter.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableDisplay{
            return 44
        }
        return 191
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableDisplay{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellDisplayFix", for: indexPath) as! cellDisplayFix
            cell.labelPosm.text = "\(_lstReportDisplayFix[indexPath.row].objectName)"
            cell.qty.text = "\(_lstReportDisplayFix[indexPath.row].quantity)"
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellEmployeeAtt", for: indexPath) as! cellEmployeeAtt
            cell.employeeName.text = "\(_lstReportEmpAttFilter[indexPath.row].employeeName)"
            cell.position.text = "\(_lstReportEmpAttFilter[indexPath.row].position)"
            cell.strDay = getStrDay(_lstReportEmpAttFilter[indexPath.row])
            cell.collecView.reloadData()
            return cell
        }
        
    }
    func getStrDay(_ item: EmployeeAttModel) -> [String]{
        var lstString = [String]()
        lstString.append(item.mon == "" ? "Mon: N/A": "Mon:\(item.mon)")
        lstString.append(item.tue == "" ? "Tue: N/A": "Tue:\(item.mon)")
        lstString.append(item.wed == "" ? "Wed: N/A": "Wed:\(item.mon)")
        lstString.append(item.thu == "" ? "Thu: N/A": "Thu:\(item.mon)")
        lstString.append(item.fri == "" ? "Fri: N/A": "Fri:\(item.mon)")
        lstString.append(item.sat == "" ? "Sat: N/A": "Sat:\(item.mon)")
        lstString.append(item.sun == "" ? "Sun: N/A": "Sun:\(item.mon)")
        return lstString
    }
    
}
