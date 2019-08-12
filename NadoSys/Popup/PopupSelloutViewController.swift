//
//  PopupSelloutViewControllẻViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/10/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import Toast_Swift
protocol nosellDelegate {
    func disableAddSellout()
}
class PopupSelloutViewController: UIViewController {
    @IBOutlet weak var viewSellOUt: UIView!
    var _dataOnlineController: IDataOnline!
    var _sellOutController: ISellOut!
    @IBOutlet weak var checkYes: BEMCheckBox!
    @IBOutlet weak var checkNo: BEMCheckBox!
    var delegate: nosellDelegate?
    var alert = UIAlertController()
    var bemGroup: BEMCheckBoxGroup = BEMCheckBoxGroup()
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    override func viewDidLoad() {
        super.viewDidLoad()
        checkYes.boxType = .circle
        checkNo.boxType = .circle
       
        bemGroup.addCheckBox(toGroup: checkYes)
        bemGroup.addCheckBox(toGroup: checkNo)
        checkYes.on = true
        showAnimate()
        // Do any additional setup after loading the view.
    }
    func updateUI(){
        viewSellOUt.layer.cornerRadius = 15
        viewSellOUt.layer.borderWidth = 1
    }
    
    @IBAction func Close(_ sender: Any) {
        removeAnimate()
    }
    @IBAction func Confirm(_ sender: Any) {
        if checkNo.on == true {
            alert = UIAlertController(title: nil, message: "Bạn đã chọn NO SELL, thao tác này sẽ khoá báo cáo sell out/số bán, bạn có chắc chắn thực hiện không?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { (result : UIAlertAction) -> Void in
                var _listSellOut = self.getSellOut()
                self._sellOutController.Insert(_listSellOut)
                self._dataOnlineController.SaveInfo(Function.getJson(self.toJson(_listSellOut[0])), url: URLs.URL_SELLOUT_SAVEDATA, completionHandler: { (data, error) in
                    if data != nil{
                        self.view.makeToast("Lưu thành công")
                        self.removeAnimate()
                        self.delegate?.disableAddSellout()
                    }
                })
            })
            alert.addAction(UIAlertAction(title: "No", style: .default) { (result : UIAlertAction) -> Void in
               // self.removeAnimate()
            })
            self.present(alert, animated: true){
                self.alert.view.superview?.subviews.first?.isUserInteractionEnabled = true
                
                // Adding Tap Gesture to Overlay
                self.alert.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
            }
        }
        else{
            removeAnimate()
        }
        //        if checkNo.on == true {
        //            guard(self.navigationController?.popViewController(animated: true)) != nil
        //                else{
        //                    self.dismiss(animated: true, completion: nil)
        //                    return
        //            }
        //            workResult.updateOrderResult(AUDITID, orderResult: 0)
        //        }
        //        else{
        //            workResult.updateOrderResult(AUDITID, orderResult: 1)
        //            removeAnimate()
        //
        //        }
    }
    
    @objc func actionSheetBackgroundTapped() {
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    func getSellOut() -> [SellOutModel]{
        var results = [SellOutModel]()
        let sellout = SellOutModel()
        sellout.saleDate = Date().toShortTimeString()
        sellout.createDate = Date().toLongTimeString()
        sellout.productId = -1
        sellout.shopId = _shopId!
        sellout.employeeId = (_login?.employeeId)!
        sellout.price = 0.0
        sellout.dealerId = 0
        sellout.qty = 0
        sellout.blockStatus = -1
        sellout.changed = 0
        sellout.objId = 8
        results.append(sellout)
        
        return results
    }
    
    func toJson(_ item: SellOutModel) -> [Dictionary<String, AnyObject>] {
        var selloutResults: [Dictionary<String, AnyObject>] = []
        var dictS  : [String : AnyObject] = [:]
        dictS = [
            "ProductId": -1 as AnyObject,
            "EmployeeId": item.employeeId as AnyObject,
            "ShopId": item.shopId as AnyObject,
            "SaleDate": item.saleDate as AnyObject,
            "Quantity": item.qty as AnyObject,
            "Price": item.price as AnyObject,
            "BlockStatus": item.blockStatus as AnyObject,
            "ObjId": item.objId as AnyObject,
            "DealerId": item.dealerId as AnyObject
            
            ]
        
        selloutResults.append(dictS )
        
        return selloutResults
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.8
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (finished: Bool) in
            if(finished){
                self.updateUI()
            }
        }
        
        
    }
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }) { (finish: Bool) in
            if(finish){
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
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
