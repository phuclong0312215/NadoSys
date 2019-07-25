//
//  ObjectDataListViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/18/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegateSelectObjectData {
    func get(_ object: ObjectDataModel)
}
class ObjectDataListViewController: UIViewController {
    var _delegate: delegateSelectObjectData?
    var _objectName = ""
    var resultSearchController = UISearchController()
    var _listObjs = [ObjectDataModel]()
    var _listFilter = [ObjectDataModel]()
    var _dataOfflineController: IDataOffline!
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
        // Do any additional setup after loading the view.
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
extension ObjectDataListViewController: UITableViewDelegate,UITableViewDataSource{
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
            return _listObjs.count
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
            _delegate?.get(_listObjs[indexPath.row])
        }
        guard(navigationController?.popViewController(animated: true)) != nil
            else{
                dismiss(animated: true, completion: nil)
                return
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellObjectDataList", for: indexPath) as! cellModelList
        if (self.resultSearchController.isActive) {
            cell.labelModel.text = _listFilter[indexPath.row].objectName
        }
        else {
            cell.labelModel.text = _listObjs[indexPath.row].objectName
        }
        if _objectName == _listObjs[indexPath.row].objectName {
            cell.imgCheck.image = UIImage(named: "ic_checked")
        }
        else{
            cell.imgCheck.image = UIImage(named: "ic_uncheck")
        }
        return cell
        
    }
}
extension ObjectDataListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        _listFilter.removeAll()
        _listFilter = _listObjs.filter { $0.objectName.contains(searchController.searchBar.text!) }
        updateTableView()
    }
    
}


