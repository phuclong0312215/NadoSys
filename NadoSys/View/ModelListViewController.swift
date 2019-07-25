//
//  ModelListViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/17/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegateSelectModel {
    func get(_ listModel: [ProductModel])
}
class ModelListViewController: UIViewController {
    
    @IBOutlet weak var countModelSelect: UILabel!
    var _strModel: String = ""
    var _delegate: delegateSelectModel?
    var resultSearchController = UISearchController()
    var _listModels = [ProductModel]()
    var _listFilter = [ProductModel]()
    var _dataOfflineController: IDataOffline!
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
        getModels()
        // Do any additional setup after loading the view.
    }
    func getModels(){
        _listModels = _dataOfflineController.GetListProductss()!
        _listFilter = _listModels
        if _strModel != "" {
            setCheck(_listFilter)
        }
        updateTableView()
    }
    
    func setCheck(_ list: [ProductModel]){
        if list.count > 0 {
            for item in list{
                if _strModel.contains(item.model){
                    item.isCheck = 1
                }
            }
        }
    }
    
    @IBAction func selectModel(_ sender: Any) {
        let listSelect = _listModels.filter{$0.isCheck == 1}
        _delegate?.get(listSelect)
        guard(navigationController?.popViewController(animated: true)) != nil
            else{
                dismiss(animated: true, completion: nil)
                return
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
extension ModelListViewController: UITableViewDelegate,UITableViewDataSource{
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
            return _listModels.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = myTable.cellForRow(at: indexPath) as! cellModelList
        if (self.resultSearchController.isActive) {
            if _listFilter[indexPath.row].isCheck == 0{
                cell.imgCheck.image = UIImage(named: "ic_checked")
                _listFilter[indexPath.row].isCheck = 1
                _listModels.filter{$0.model == _listFilter[indexPath.row].model}.first?.isCheck = 1
            }
            else{
                cell.imgCheck.image = UIImage(named: "ic_uncheck")
                _listFilter[indexPath.row].isCheck = 0
                _listModels.filter{$0.model == _listFilter[indexPath.row].model}.first?.isCheck = 0
            }
        }
        else {
            if _listModels[indexPath.row].isCheck == 0{
                cell.imgCheck.image = UIImage(named: "ic_checked")
                _listModels[indexPath.row].isCheck = 1
            }
            else{
                cell.imgCheck.image = UIImage(named: "ic_uncheck")
                _listModels[indexPath.row].isCheck = 0
            }
        }
        countModelSelect.text = "\(_listModels.filter{$0.isCheck == 1}.count) models selected"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellModelList", for: indexPath) as! cellModelList
        if (self.resultSearchController.isActive) {
            cell.labelModel.text = _listFilter[indexPath.row].model
            if _listFilter[indexPath.row].isCheck == 1 {
                cell.imgCheck.image = UIImage(named: "ic_checked")
            }
            else{
                cell.imgCheck.image = UIImage(named: "ic_uncheck")
            }
        }
        else {
            
            cell.labelModel.text = _listModels[indexPath.row].model
            if _listModels[indexPath.row].isCheck == 1 {
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
extension ModelListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        _listFilter.removeAll()
        _listFilter = _listModels.filter { $0.model.contains(searchController.searchBar.text!) }
        updateTableView()
    }
    
}
