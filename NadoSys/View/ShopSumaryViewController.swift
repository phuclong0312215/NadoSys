//
//  ShopSumaryViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/31/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class ShopSumaryViewController: UIViewController {
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var _lstMts = [ReportMarketShopModel]()
    var _lstGts = [ReportMarketShopModel]()
    var _dataOnlineController: IDataOnline!
    var _login = Defaults.getUser(key: "LOGIN")
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "frmShopDirect")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "frmSubDealer")
        
        return secondChildTabVC
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
         SVProgressHUD.show()
        _dataOnlineController.GetReportMarketShop((_login?.employeeId)!) { (dataMts, dataGts, error) in
            if dataMts != nil{
                self._lstMts = dataMts!
            }
            if dataGts != nil{
                self._lstGts = dataGts!
            }
            self.segmentControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
            self.displayCurrentTab(TabIndex.firstChildTab.rawValue)
            SVProgressHUD.dismiss()
        }
       
       
        
        // Do any additional setup after loading the view.
    }
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title:"Shop Profile", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title:"NDS", style:.plain, target:nil, action:nil)
    }
    func setNavigationBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x1966a7)
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        addRightButton()
    }

    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.viewContainer.bounds
            self.viewContainer.addSubview(vc.view)
            self.currentViewController = vc
            vc.view.layoutIfNeeded()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        
        switch index {
        case TabIndex.firstChildTab.rawValue :
            let vc = firstChildTabVC as! ShopDirectViewController
            setGroupByTitle(_lstMts)
            vc._lstMts = _lstMts
            
            return vc
        case TabIndex.secondChildTab.rawValue :
            let vc = secondChildTabVC as! ShopSubDealerViewController
            setGroupByTitle(_lstGts)
            vc._lstGts = _lstGts
            return vc
        default:
            return nil
        }
    }
    func setGroupByTitle(_ arrReport: [ReportMarketShopModel]){
        var headerGroup: String = ""
        for p in arrReport {
            
            if(headerGroup.contains(p.title)){
                continue
            }
            else{
                headerGroup += p.title + ";"
                p.groupBy = p.title
            }
            
        }
    }
    @IBAction func valueChange(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)
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
