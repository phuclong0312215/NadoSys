//
//  MainViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/8/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var viewNDS: UIView!
    @IBOutlet weak var viewTraining: UIView!
    @IBOutlet weak var viewOperation: UIView!
    @IBOutlet weak var viewTeam: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var viewMarketSensing: UIView!
    var _dataOfflineController: IDataOffline!
    var _login = Defaults.getUser(key: "LOGIN")
    var _countDownload = 0
    var _maxDownload = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        let shops = _dataOfflineController.GetListShops((_login?.employeeId)!)
        let regions = _dataOfflineController.GetListRegions()
        if shops == nil && regions == nil{
            _maxDownload = _maxDownload + 1
        }
        if shops != nil && regions != nil {
         SVProgressHUD.dismiss()
        }
        
        let queue = DispatchQueue(label: "com.downloaddata")
        if shops == nil || (shops?.count)! == 0{
            SVProgressHUD.show(withStatus: "Đang cập nhật dữ liệu, vui lòng chờ…")
            queue.async {
                self._dataOfflineController.DownloadData { (flag) in
                    DispatchQueue.main.async {
                        if flag == true{
                            self._countDownload = self._countDownload + 1
                            if self._countDownload == self._maxDownload {
                                self.view.makeToast("Cập nhật dữ liệu thành công")
                                SVProgressHUD.dismiss()
                            }
                        }
                        
                    }
                }
            }
        }
        if regions == nil || (regions?.count)! == 0{
            queue.async {
                if self._maxDownload == 1 {
                      SVProgressHUD.show(withStatus: "Đang cập nhật dữ liệu, vui lòng chờ…")
                }
                self._dataOfflineController.DownloadDataRegion { (flag) in
                    DispatchQueue.main.async {
                        if flag == true{
                            self._countDownload = self._countDownload + 1
                            if self._countDownload == self._maxDownload {
                                self.view.makeToast("Cập nhật dữ liệu thành công")
                                SVProgressHUD.dismiss()
                            }
                        }
                        
                    }
                }
            }
            
        }
        let doMarketSensing = UITapGestureRecognizer(target: self, action:  #selector(self.DoMarketSensing))
        self.viewMarketSensing.addGestureRecognizer(doMarketSensing)
        let doOperation = UITapGestureRecognizer(target: self, action:  #selector(self.DoOperation))
        self.viewOperation.addGestureRecognizer(doOperation)
        let doTraining = UITapGestureRecognizer(target: self, action:  #selector(self.DoTraining))
        self.viewTraining.addGestureRecognizer(doTraining)
        let doTeam = UITapGestureRecognizer(target: self, action:  #selector(self.DoTeam))
        self.viewTeam.addGestureRecognizer(doTeam)
      //  setNavigationBar()
        if self.revealViewController() != nil {
            self.revealViewController()?.viewDidLoad()
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        viewNDS.setBorder(radius: 4)
        viewTraining.setBorder(radius: 4)
        viewOperation.setBorder(radius: 4)
        viewTeam.setBorder(radius: 4)
        viewMarketSensing.setBorder(radius: 4)
       
        // Do any additional setup after loading the view.
    }
    func setNavigationBar(){
          navigationController?.navigationBar.isHidden = true
    }
    
    @objc func DoOperation(sender : UITapGestureRecognizer) {
        // Do what you want
        Function.Message("Info", message: "Comming soon")
    }
    @objc func DoTraining(sender : UITapGestureRecognizer) {
        // Do what you want
        Function.Message("Info", message: "Comming soon")
    }
    @objc func DoTeam(sender : UITapGestureRecognizer) {
        // Do what you want
        Function.Message("Info", message: "Comming soon")
    }
    @objc func DoMarketSensing(sender : UITapGestureRecognizer) {
        // Do what you want
//       var objects = _dataOfflineController.GetListKPIs()
//        let obj = objects?.filter{$0.id == 1012}.first
//        if obj != nil {
//             pushViewController(withIdentifier: "frmRouter")
//        }
//        else{
//             pushViewController(withIdentifier: "frmShop")
//        }
        let tc = DashboardViewController()
      //  navigationController?.pushViewController(tc, animated: true)
       pushViewController(withIdentifier: "frmShopSumary")
       // pushViewController(withIdentifier: "frmA")
      
    }

    @IBAction func back(_ sender: Any) {
        guard(navigationController?.popViewController(animated: true)) != nil
            else{
                dismiss(animated: true, completion: nil)
                return
        }
    }
    
    @IBAction func openMenu(_ sender: Any) {
         self.revealViewController()?.revealToggle(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
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
