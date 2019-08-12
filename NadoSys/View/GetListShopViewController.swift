//
//  GetListShopViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/5/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class GetListShopViewController: UIViewController {

    var pickPS: UIPickerView = UIPickerView()
    @IBOutlet weak var txtPS: UITextField!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var _myTable: UITableView!
    var resultSearchController = UISearchController()
    var _listShops = [ShopModel]()
    var _listFilter = [ShopModel]()
    var _lstPS = [String]()
    var _objectName = ""
    var _dataOnlineController: IDataOnline!
    var _login = Defaults.getUser(key: "LOGIN")
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        txtSearch.delegate = self
        _myTable.delegate = self
        _myTable.dataSource = self
        pickPS.dataSource = self
        pickPS.delegate = self
        txtPS.inputView = pickPS
        txtPS.delegate = self
        txtPS.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
       // getShops()
        // Do any additional setup after loading the view.
    }
    
    func getShops(){
        labelTotal.text = "\(_listShops.count) stores"
        updateTableView()
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x1966a7)
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        addRightButton()
    }
    
    
    
    func addRightButton(){ 
       
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title:"NDS", style:.plain, target:nil, action:nil)
             self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title:"List shop of \(_objectName)", style:.plain, target:nil, action:nil)
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
extension GetListShopViewController: UITableViewDelegate,UITableViewDataSource{
    func updateTableView(){
        _myTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _listFilter.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Preferences.put(key: "SHOPID", value: "\(_listFilter[indexPath.row].shopId)")
        Preferences.put(key: "SHOPNAME", value: _listFilter[indexPath.row].shopName)
        pushViewController(withIdentifier: "frmEmployeeShopProfile")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellGetListShop", for: indexPath) as! cellShop
        cell.lbShopName.text = "\(indexPath.row + 1). \(_listFilter[indexPath.row].shopName)"
        cell.lbShopCode.text = "Mã CH: \(_listFilter[indexPath.row].shopCode)"
        cell.lbShopAddress.text = _listFilter[indexPath.row].address
        return cell
        
    }
}
extension GetListShopViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
        
        _listFilter.removeAll()
        if substring == "" {
            _listFilter = _listShops
        }
        else{
            _listFilter = _listShops.filter { $0.shopName.contains(substring) ||  $0.shopCode.contains(substring)}
        }
        labelTotal.text = "\(_listFilter.count) stores"
        updateTableView()
        
    }
}
extension GetListShopViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func updatePickerView(_ pickerView: UIPickerView){
        pickPS.reloadAllComponents()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _lstPS.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _lstPS[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtPS.text = _lstPS[row]
//        if pickPS.selectedRow(inComponent: 0) > 0{
//
//           // _listFilter = _listShops?.filter{$0.is == _categorys[row].categoryCode}
//        }
//        else{
//            arrModel = arrFilter
//        }
        
        _myTable.reloadData()
        
    }
    
}

