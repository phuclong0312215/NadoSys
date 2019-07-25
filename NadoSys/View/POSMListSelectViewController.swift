//
//  POSMListSelectViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/20/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegateSelectPosm {
    func get(_ listPosm: [POSMModel])
}
class POSMListSelectViewController: UIViewController {
    var alert: UIAlertController!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var countModelSelect: UILabel!
    var _delegate: delegateSelectPosm?
    
    @IBOutlet weak var txtCate: UITextField!
    @IBOutlet weak var txtSearch: UITextField!
    var _listPosmOlds = [POSMModel]()
    var _listPosms = [POSMModel]()
    var _listFilter = [POSMModel]()
    var _dataOnlineController: IDataOnline!
   // var _sellOutController: ISellOut!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        txtSearch.delegate = self
        getPOSM()
        addRightButton()
         txtCate.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        // Do any additional setup after loading the view.
    }
    
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Chọn POSM", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title: "NDS", style:.plain, target:nil, action:nil)
    }
    
    func getPOSM(){
        
        _dataOnlineController.GetPosmByEmployeeId((_login?.employeeId)!) { (data, error) in
            DispatchQueue.main.async {
                if data != nil{
                    self._listPosms = data!
                    self._listFilter = self._listPosms
                    if self._listPosmOlds != nil &&  self._listPosmOlds.count > 0 {
                        self.setCheck(self._listPosms)
                    }
                    self.updateTableView()
                }
            }
        }
       
       // updateTableView()
    }

    func setCheck(_ list: [POSMModel]){
        if list.count > 0 {
            for item in list{
                let posm = _listPosmOlds.filter{$0.id == item.id}.first
                if posm != nil {
                    item.isCheck = 1
                    item.quantity = (posm?.quantity)!
                }
            }
        }
    }
    
    @IBAction func selectModel(_ sender: Any) {
        let listSelect = _listPosms.filter{$0.isCheck == 1}
        // let listSellOut =  getListModelCheck(listSelect)
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
extension POSMListSelectViewController: UITableViewDelegate,UITableViewDataSource{
    func updateTableView(){
        myTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _listFilter.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = myTable.cellForRow(at: indexPath) as! cellModelList
        
        if _listFilter[indexPath.row].isCheck == 0{
            cell.imgCheck.image = UIImage(named: "ic_checked")
            _listFilter[indexPath.row].isCheck = 1
        }
        else{
//            if _listPosms[indexPath.row].quantity > 0{
//                alertCheck(_listModels[indexPath.row])
//            }
            cell.imgCheck.image = UIImage(named: "ic_uncheck")
            _listFilter[indexPath.row].isCheck = 0
        }
        
        countModelSelect.text = "\(_listFilter.filter{$0.isCheck == 1}.count) models selected"
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
//        if _listPosms[indexPath.row].quantity > 0{
//            cell.labelCountModel.text = "SL: \(_listModels[indexPath.row].quantity)"
//        }
//        else{
//            cell.labelCountModel.text = ""
//        }
        cell.labelModel.text = _listFilter[indexPath.row].itemName
        if _listFilter[indexPath.row].isCheck == 1 {
            cell.imgCheck.image = UIImage(named: "ic_checked")
        }
        else{
            cell.imgCheck.image = UIImage(named: "ic_uncheck")
        }
        
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
        
    }
}

extension POSMListSelectViewController: UITextFieldDelegate{
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
            _listFilter = _listPosms
        }
        else{
            _listFilter = _listPosms.filter { $0.itemName.lowercased().contains(substring.lowercased()) ||  $0.itemCode.lowercased().contains(substring.lowercased())}
        }
        updateTableView()
        
    }
}
