//
//  LocationViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/18/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import Foundation
protocol locationDelegate {
    func setLocation(_ location: RegionSelectModel, locationType: String)
}
class LocationViewController: UIViewController {

    var resultSearchController = UISearchController()
    var _delegate: locationDelegate?
    var _type = ""
    var _districtId = 0
    var _wardId = 0
    var _provinceId = 0
    var _locationId = 0
    var _listRegion = [RegionSelectModel]()
    var _listFilter = [RegionSelectModel]()
    var _dataOfflineController: IDataOffline!
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            self.myTable.tableHeaderView = controller.searchBar
            return controller
        })()
        myTable.delegate = self
        myTable.dataSource = self
        getLocations()
        // Do any additional setup after loading the view.
    }
    func getLocations(){
        var provinces = [ProvinceModel]()
        var districts = [DistrictModel]()
        var wards = [WardModel]()
        if _type == "PROVINCE" {
            provinces = _dataOfflineController.GetListProvinces()!
        }
        else if _type == "DISTRICT"{
            districts = _dataOfflineController.GetListDistrict(_provinceId)!
        }
        else{
            wards = _dataOfflineController.GetListWard(_districtId)!
        }
        _listRegion = convertToRegionName(provinces,districts: districts,wards: wards)
//        let model = RegionSelectModel()
//        model.id = 0
//        model.name = "-- Chọn --"
//        _listRegion.append(model)
        _listFilter = _listRegion
        updateTableView()
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x1966a7)
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    func convertToRegionName(_ provinces: [ProvinceModel],districts: [DistrictModel],wards: [WardModel]) -> [RegionSelectModel] {
        var results = [RegionSelectModel]()
        if _type == "PROVINCE"{
            for item in provinces{
                let regionSelect = RegionSelectModel()
                regionSelect.id = item.provinceId
                regionSelect.name = item.provinceName
                regionSelect.name_vn = item.provinceName_Vi_vn
                results.append(regionSelect)
            }
        }
        else if _type == "DISTRICT"{
            for item in districts{
                let regionSelect = RegionSelectModel()
                regionSelect.id = item.districtId
                regionSelect.name = item.districtName
                regionSelect.name_vn = item.districtName_Vi_vn
                results.append(regionSelect)
            }
        }
        else{
            for item in wards{
                let regionSelect = RegionSelectModel()
                regionSelect.id = item.wardId
                regionSelect.name = item.wardName
                regionSelect.name_vn = item.wardName_Vi_vn
                results.append(regionSelect)
            }
        }
        return results
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
extension LocationViewController: UITableViewDelegate,UITableViewDataSource{
    func updateTableView(){
        myTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive) {
            return _listFilter.count
        }
        else {
            return _listRegion.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.resultSearchController.isActive) {
            _delegate?.setLocation(_listFilter[indexPath.row],locationType: _type)
        }
        else {
            _delegate?.setLocation(_listRegion[indexPath.row],locationType: _type)
        }
        guard(navigationController?.popViewController(animated: true)) != nil
            else{
                dismiss(animated: true, completion: nil)
                return
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLocation", for: indexPath) as! cellLocation
        if (self.resultSearchController.isActive) {
            cell.name.text = _listFilter[indexPath.row].name_vn
        }
        else {
            cell.name.text = _listRegion[indexPath.row].name_vn
        }
        if _locationId == _listRegion[indexPath.row].id {
            cell.img.image = UIImage(named: "ic_checked")
        }
        else{
            cell.img.image = UIImage(named: "ic_location")
        }
        return cell
        
    }
}
extension LocationViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        _listFilter.removeAll()
        _listFilter = _listRegion.filter { $0.name.contains(searchController.searchBar.text!) }
        updateTableView()
    }
    
}

