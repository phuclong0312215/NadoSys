//
//  SupplierListViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/5/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegateSelectSupplierData {
    func get(_ object: ShopModel)
}
class SupplierListViewController: UIViewController {

    var _supplierId: Int = 0
    var _delegate: delegateSelectSupplierData?
    var resultSearchController = UISearchController()
    var _listShops = [ShopModel]()
    var _listFilter = [ShopModel]()
    var _dataOfflineController: IDataOffline!
    var _login = Defaults.getUser(key: "LOGIN")
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        getSupplier()
        // Do any additional setup after loading the view.
    }
    func getSupplier(){
        _listShops = _dataOfflineController.GetListShops((_login?.employeeId)!)!
        _listFilter = _listShops
        if _supplierId > 0{
            _listFilter.filter{$0.shopId == _supplierId}.first?.isCheck = 1
        }
        updateTableView()
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
extension SupplierListViewController: UITableViewDelegate,UITableViewDataSource{
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
            return _listShops.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.resultSearchController.isActive) {
            _delegate?.get(_listFilter[indexPath.row])
        }
        else {
            _delegate?.get(_listShops[indexPath.row])
        }
        guard(navigationController?.popViewController(animated: true)) != nil
            else{
                dismiss(animated: true, completion: nil)
                return
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellModelList", for: indexPath) as! cellModelList
        if (self.resultSearchController.isActive) {
            cell.labelModel.text = "\(_listFilter[indexPath.row].shopCode),\(_listFilter[indexPath.row].shopName)"
            if _listFilter[indexPath.row].isCheck == 1 {
                cell.imgCheck.image = UIImage(named: "ic_checked")
            }
            else{
                cell.imgCheck.image = UIImage(named: "ic_uncheck")
            }
        }
        else {
            cell.labelModel.text = "\(_listShops[indexPath.row].shopCode),\(_listShops[indexPath.row].shopName)"
            if _listShops[indexPath.row].isCheck == 1 {
                cell.imgCheck.image = UIImage(named: "ic_checked")
            }
            else{
                cell.imgCheck.image = UIImage(named: "ic_uncheck")
            }
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
        
    }
}
extension SupplierListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        _listFilter.removeAll()
        _listFilter = _listShops.filter { $0.shopCode.contains(searchController.searchBar.text!) || $0.shopName.contains(searchController.searchBar.text!)}
        updateTableView()
    }
    
}

