//
//  ShopViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/8/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var _myTable: UITableView!
    var resultSearchController = UISearchController()
    var _listShops = [ShopModel]()
    var _listFilter = [ShopModel]()
    var _dataOfflineController: IDataOffline!
    var _login = Defaults.getUser(key: "LOGIN")
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        txtSearch.delegate = self
        _myTable.delegate = self
        _myTable.dataSource = self
        getShops()
        // Do any additional setup after loading the view.
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
       
        let viewFN = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button1.setImage(UIImage(named: "ic_signout_white"), for: UIControl.State.normal)
       // button1.setTitle("one", for: .normal)
  
        
        let button2 = UIButton(frame: CGRect(x: 30, y: 0, width: 25, height: 25))
        button2.setImage(UIImage(named: "ic_user_white"), for: UIControl.State.normal)
       // button2.setTitle("tow", for: .normal)
        let button3 = UIButton(frame: CGRect(x: 60, y: 0, width: 25, height: 25))
        button3.setImage(UIImage(named: "ic_lock_white"), for: UIControl.State.normal)
       // button3.setTitle("three", for: .normal)
        
        button3.addTarget(self, action: #selector(self.back(_:)), for: UIControl.Event.touchUpInside)
       // viewFN.addSubview(label)
        viewFN.addSubview(button1)
        viewFN.addSubview(button2)
        viewFN.addSubview(button3)
        
        
        let rightBarButton = UIBarButtonItem(customView: viewFN)
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title:"NDS", style:.plain, target:nil, action:nil)
       // self.navigationItem.leftBarButtonItem?.title = "NDS"
        let height: CGFloat = 50 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
       // self.navigationController?.navigationBar.hei
      //  self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 230)

    }
    
    @IBAction func back(_ sender: Any) {
        guard(navigationController?.popViewController(animated: true)) != nil
            else{
                dismiss(animated: true, completion: nil)
                return
        }
    }
    func getShops(){
        _listShops = _dataOfflineController.GetListShops((_login?.employeeId)!)!
        _listFilter = _listShops
        labelTotal.text = "\(_listShops.count) stores"
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
extension ShopViewController: UITableViewDelegate,UITableViewDataSource{
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
        pushViewController(withIdentifier: "frmKPI")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellShop", for: indexPath) as! cellShop
        cell.lbShopName.text = "\(indexPath.row + 1). \(_listFilter[indexPath.row].shopName)"
        cell.lbShopCode.text = "Mã CH: \(_listFilter[indexPath.row].shopCode)"
        cell.lbShopAddress.text = _listFilter[indexPath.row].address
        return cell
        
    }
}
extension ShopViewController: UITextFieldDelegate{
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
