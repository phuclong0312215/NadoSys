//
//  DisplayDataViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/13/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
class DisplayDataViewController: UIViewController {
    @IBOutlet weak var txtCate: UITextField!
    @IBOutlet weak var labelUpdate: UILabel!
    @IBOutlet weak var viewModel: UIView!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var totalWM: UIButton!
    @IBOutlet weak var totalREF: UIButton!
    @IBOutlet weak var totalAC: UIButton!
    @IBOutlet weak var totalAll: UIButton!
    var pickCategory: UIPickerView = UIPickerView()
    @IBOutlet weak var collecTotal: UICollectionView!
    var _categorys: [ProductModel] = []
    var _lstTotal: [ProductModel] = []
    var _displayController: IDisplay!
    var _dataOfflineController: IDataOffline!
    var _dataOnlineController: IDataOnline!
    var arrModel : [DisplayModel]? = []
    var arrFilter : [DisplayModel]? = []
    var _indexPath = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collecTotal.delegate = self
        collecTotal.dataSource = self
        txtSearch.delegate = self
        myTable.delegate = self
        myTable.dataSource = self
        pickCategory.dataSource = self
        pickCategory.delegate = self
        txtCate.inputView = pickCategory
        txtCate.delegate = self
        _categorys  = _dataOfflineController.GetCategory()!
        _lstTotal = _categorys
        var item = ProductModel()
        item.categoryCode = "Total"
        _lstTotal.insert(item, at: 0)
        setTotal()
        item = ProductModel()
        item.categoryCode = "Select All"
        viewModel.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        txtCate.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        txtCate.text = "Category"
        labelUpdate.text = "Cập nhật: \(Date().toShortTimeString())"
        _categorys.insert(item, at: 0)
        //setDropDown()
       
        // Do any additional setup after loading the view.
    }
    
//    func setDropDown(){
//
//       // ddCate.frame = CGRect(x: 9, y: 36, width: 101, height: 30)
//
//        if categorys != nil && (categorys?.count)! > 0{
//            for item in categorys!{
//                _arrCatCode.append(item.categoryCode)
//            }
//        }
//
//    }
    
    func toJson(_ lst: [DisplayModel]) -> [Dictionary<String, AnyObject>] {
        var displayResults: [Dictionary<String, AnyObject>] = []
        for item in lst{
            let dictS  : [String : AnyObject] = [
                "Id": 0 as AnyObject,
                "ProductId": item.productId as AnyObject,
                "EmployeeId": item.employeeId as AnyObject,
                "ShopId": item.shopId as AnyObject,
                "ReportDate": Date().toShortTimeString() as AnyObject,
                "Timing": Date().toLongTimeString() as AnyObject,
                "CategoryCode": item.categoryCode as AnyObject,
                "CompetitorId": item.competitorId as AnyObject,
                "Qty": item.qty as AnyObject
            ]
            displayResults.append(dictS )
        }
        return displayResults
    }
    
    
    @IBAction func save(_ sender: Any) {
        SVProgressHUD.show()
        _dataOnlineController.SaveInfo(Function.getJson(toJson(arrModel!)), url: URLs.URL_DISPLAY_SAVEDATA) { (data, error) in
            DispatchQueue.main.async {
                if data != nil {
                    Function.Message("Thông báo", message: "Lưu thành công")
                }
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func setTotal(){
        for item in _lstTotal {
            if item.categoryCode != "Total"{
                item.total = (arrFilter?.filter{$0.categoryCode == item.categoryCode}.map({$0.qty}).reduce(0,+))!
            }
            else{
                 item.total = (arrFilter?.map({$0.qty}).reduce(0,+))!
            }
            //_lstTotal.append(item)
        }
        updateCell()
    }
    
    @objc func updateValue(_ textField: UITextField){
        let row = textField.tag
        var quantity = 0
        if(textField.text != ""){
            quantity = Int(textField.text!)!
        }
        if quantity < 0 {
            Function.Message("Info", message: "The number must be greater than or equal to 0")
            return
        }
        arrModel![row].qty = quantity
        arrFilter?.filter{$0.model == arrModel![row].model}.first?.qty = quantity
        let statusGuideline = arrModel![row].qty - arrModel![row].guideLine
        let cell = myTable.cellForRow(at: IndexPath(row: row, section: 0)) as! cellModelDisplay
        if statusGuideline < 0 {
            cell.imgGuideline.image = UIImage(named: "ic_warning_yellow")
            cell.statulGuideline.text = "(\(abs(statusGuideline)))"
        }
        else{
            if statusGuideline == 0 {
                cell.statulGuideline.text = "-"
            }
            else{
                cell.statulGuideline.text = "\(abs(statusGuideline))"
            }
            cell.imgGuideline.image = UIImage(named: "ic_tick")
        }
        
        setTotal()
        _displayController.save(arrModel![row],type: "MODEL")
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
extension DisplayDataViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(arrModel == nil){
            return 0
        }
        return arrModel!.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(arrModel![indexPath.row].groupBy == nil || arrModel![indexPath.row].groupBy == ""){
            return 77
        }
        else{
            return 109
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellModelDisplay", for: indexPath) as! cellModelDisplay
        cell.btnCate.setRounded(radius: 6)
        cell.btnCate.setTitle("\(arrModel![indexPath.row].categoryCode)", for: .normal)
        cell.labelCate.text = "\(arrModel![indexPath.row].categoryCode)"
        cell.labelModel.text = "\(indexPath.row + 1). \(arrModel![indexPath.row].model)"
        cell.labelGuideline.text = "Guide Line: \(arrModel![indexPath.row].guideLine)"
        cell.txtValue.text = "\(arrModel![indexPath.row].qty)"
        cell.txtValue.tag = indexPath.row
        cell.txtValue.addTarget(self, action: #selector(DisplayDataViewController.updateValue(_:)), for: UIControl.Event.editingChanged)
        cell.delegate = self
        let statusGuideline = arrModel![indexPath.row].qty - arrModel![indexPath.row].guideLine
        if statusGuideline < 0 {
            cell.imgGuideline.image = UIImage(named: "ic_warning_yellow")
            cell.statulGuideline.text = "(\(abs(statusGuideline)))"
        }
        else{
            if statusGuideline == 0 {
                cell.statulGuideline.text = "-"
            }
            else{
                cell.statulGuideline.text = "\(abs(statusGuideline))"
            }
            cell.imgGuideline.image = UIImage(named: "ic_tick")
        }
        if(arrModel![indexPath.row].groupBy == nil || arrModel![indexPath.row].groupBy == ""){
            cell.viewCate.isHidden = true
            cell.contrainHeight.constant = 0
        }
        else{
            cell.viewCate.isHidden = false
            
            cell.contrainHeight.constant = 31
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
}
extension DisplayDataViewController: delegateDisplay{
    func cal(for cell: cellModelDisplay, size: Int) {
        guard let indexPath = myTable.indexPath(for: cell) else {
            return
        }
        self._indexPath = indexPath.row
        let quantity = arrModel![_indexPath].qty + size
        if quantity < 0 {
            Function.Message("Info", message: "The number must be greater than or equal to 0")
            return
        }
        arrModel![_indexPath].qty = quantity
        arrFilter?.filter{$0.model == arrModel![_indexPath].model}.first?.qty = quantity
        cell.txtValue.text = "\(quantity)"
        let statusGuideline = arrModel![_indexPath].qty - arrModel![_indexPath].guideLine
        if statusGuideline < 0 {
            cell.imgGuideline.image = UIImage(named: "ic_warning_yellow")
            cell.statulGuideline.text = "(\(abs(statusGuideline)))"
        }
        else{
            if statusGuideline == 0 {
                cell.statulGuideline.text = "-"
            }
            else{
                cell.statulGuideline.text = "\(abs(statusGuideline))"
            }
            cell.imgGuideline.image = UIImage(named: "ic_tick")
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        setTotal()
        _displayController.save(arrModel![_indexPath],type: "MODEL")
    }
    
    
}

extension DisplayDataViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func updatePickerView(_ pickerView: UIPickerView){
        pickCategory.reloadAllComponents()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _categorys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _categorys[row].categoryCode
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCate.text = _categorys[row].categoryCode
        if pickCategory.selectedRow(inComponent: 0) > 0{
            
            arrModel = arrFilter?.filter{$0.categoryCode == _categorys[row].categoryCode}
        }
        else{
            arrModel = arrFilter
        }
        
        myTable.reloadData()
       
    }
    
}

extension DisplayDataViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func updateCell(){
        for i in 0..<_lstTotal.count{
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = collecTotal.cellForItem(at: indexPath) as? cellTotal {
                cell.buttonTotal.setTitle("\(_lstTotal[i].categoryCode): \(_lstTotal[i].total)", for: .normal)
            }
        }
    }
    

    
    func updateUI(){
        collecTotal.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (_lstTotal.count)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTotal", for: indexPath) as! cellTotal
        cell.buttonTotal.setRounded(radius: 6)
        cell.buttonTotal.setTitle("\(_lstTotal[indexPath.row].categoryCode): \(_lstTotal[indexPath.row].total)", for: .normal)
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension DisplayDataViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCate{
            return false
        }
        
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == txtSearch {
            searchAutocompleteEntriesWithSubstring(substring)
            // not sure about this - could be false
        }
        return true
    }
    func searchAutocompleteEntriesWithSubstring(_ substring: String)
    {
        //autocompleteUrls.removeAll(keepingCapacity: false)
        
        arrModel?.removeAll()
        if substring == "" {
            arrModel = arrFilter
        }
        else{
            arrModel = arrFilter!.filter { $0.model.lowercased().contains(substring.lowercased())}
        }
        
        myTable.reloadData()
        setTotal()
    }
    
}

