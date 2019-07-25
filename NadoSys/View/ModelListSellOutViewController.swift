//
//  ModelListSellOutViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/22/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegateSelectModelSellOut {
    func get(_ listModel: [SellOutModel])
}
class ModelListSellOutViewController: UIViewController {

    var alert: UIAlertController!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var countModelSelect: UILabel!
    var _delegate: delegateSelectModel?
    var resultSearchController = UISearchController()
    var _listModelOlds = [ProductModel]()
    var _listModels = [ProductModel]()
    var _listFilter = [ProductModel]()
    var _dataOfflineController: IDataOffline!
    var _sellOutController: ISellOut!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
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
        if _listModelOlds != nil &&  _listModelOlds.count > 0 {
            setCheck(_listFilter)
        }
        updateTableView()
    }
    func setCheck(_ list: [ProductModel]){
        if list.count > 0 {
            for item in list{
                let model = _listModelOlds.filter{$0.productId == item.productId}.first
                if model != nil {
                    item.isCheck = 1
                    item.quantity = (model?.quantity)!
                }
            }
        }
    }
    @IBAction func selectModel(_ sender: Any) {
        let listSelect = _listModels.filter{$0.isCheck == 1}
       // let listSellOut =  getListModelCheck(listSelect)
        _delegate?.get(listSelect)
        guard(navigationController?.popViewController(animated: true)) != nil
            else{
                dismiss(animated: true, completion: nil)
                return
        }
    }
    
//    func getListModelCheck(_ listSelect: [ProductModel]) -> [ProductModel]{
//        var results = [ProductModel]()
//        for modelSelect in listSelect {
//             let model = _listModelOlds.filter{$0.productId == modelSelect.productId}.first
//             if model == nil {
//                let sellout = SellOutModel()
//                sellout.saleDate = Date().toShortTimeString()
//                sellout.createDate = Date().toLongTimeString()
//                sellout.productId = modelSelect.productId
//                sellout.shopId = _shopId!
//                sellout.employeeId = (_login?.employeeId)!
//                sellout.price = modelSelect.price
//                sellout.dealerId = 0
//                sellout.qty = 0
//                sellout.blockStatus = 0
//                sellout.objId = 0
//                sellout.orderCode = UUID().uuidString
//                sellout.changed = 0
//                _sellOutController.Insert(sellout)
//                results.append(sellout)
//             }
//             else{
//                results.append(model!)
//            }
//        }
//        return results
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ModelListSellOutViewController: UITableViewDelegate,UITableViewDataSource{
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
                if _listFilter[indexPath.row].quantity > 0{
                    alertCheck(_listFilter[indexPath.row])
                }
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
                if _listModels[indexPath.row].quantity > 0{
                    alertCheck(_listModels[indexPath.row])
                }
                cell.imgCheck.image = UIImage(named: "ic_uncheck")
                _listModels[indexPath.row].isCheck = 0
            }
        }
        countModelSelect.text = "\(_listModels.filter{$0.isCheck == 1}.count) models selected"
    }
    
    func alertCheck(_ model: ProductModel){
        alert = UIAlertController(title: nil, message: "Model/sản phẩm có số lượng > 0 , bạn có chắc chắn bỏ sản phẩm này?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { (result : UIAlertAction) -> Void in
           model.isCheck = 0
        })
        alert.addAction(UIAlertAction(title: "No", style: .default) { (result : UIAlertAction) -> Void in
            
        })
        self.present(alert, animated: true){
            self.alert.view.superview?.subviews.first?.isUserInteractionEnabled = true
            
            // Adding Tap Gesture to Overlay
            self.alert.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
        }
    }
    @objc func actionSheetBackgroundTapped() {
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellModelListSellOut", for: indexPath) as! cellModelList
        if (self.resultSearchController.isActive) {
            cell.labelModel.text = _listFilter[indexPath.row].model
            if _listFilter[indexPath.row].quantity > 0{
                cell.labelCountModel.text = "SL: \(_listFilter[indexPath.row].quantity)"
            }
            else{
                cell.labelCountModel.text = ""
            }
            if _listFilter[indexPath.row].isCheck == 1 {
                cell.imgCheck.image = UIImage(named: "ic_checked")
            }
            else{
                cell.imgCheck.image = UIImage(named: "ic_uncheck")
            }
        }
        else {
            if _listModels[indexPath.row].quantity > 0{
                cell.labelCountModel.text = "SL: \(_listModels[indexPath.row].quantity)"
            }
            else{
                cell.labelCountModel.text = ""
            }
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
extension ModelListSellOutViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        _listFilter.removeAll()
        _listFilter = _listModels.filter { $0.model.contains(searchController.searchBar.text!) }
        updateTableView()
    }
    
}

