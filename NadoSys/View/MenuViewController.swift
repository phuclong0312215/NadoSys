//
//  MenuViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/28/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var myTable: UITableView!
    var arrMenu:[String] = ["Internal Operation Control","Team Management","Training"]
    var arrImg:[String] = ["i_operation","i_team","i_training"]
    var _dataOfflineController: IDataOffline!
    
    var _login = Defaults.getUser(key: "LOGIN")
    
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(logoutApp))
        logout.isUserInteractionEnabled = true
        logout.addGestureRecognizer(singleTap)
        
        let downloadTap = UITapGestureRecognizer(target: self, action: #selector(refreshDataOffline))
        refreshData.isUserInteractionEnabled = true
        refreshData.addGestureRecognizer(downloadTap)
        // Do any additional setup after loading the view.
        if _login != nil{
            lblName.text = "Welcome, " + _login!.employeeName
            
        }
    }
    

    @IBOutlet weak var refreshData: UIImageView!
    @IBOutlet weak var logout: UIImageView!
    @objc func logoutApp(){
         Defaults.clearUserData(key: "LOGIN")
         self.performSegue(withIdentifier: "sw_login", sender: self)
    }
    @objc func refreshDataOffline(){
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn tải lại data", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            SVProgressHUD.show(withStatus: "Đang cập nhật dữ lieu, vui lòng chờ…")
            self._dataOfflineController.DownloadData { (flag) in
                if flag == true{
                    self.view.makeToast("Tải thành công")
                }
                SVProgressHUD.dismiss()
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            guard(self.navigationController?.popViewController(animated: true)) != nil
                else{
                    self.dismiss(animated: true, completion: nil)
                    return
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
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
extension MenuViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            //pushViewController(withIdentifier: "frmHome")
//            //performSegue(withIdentifier: "sw_shop",sender: self)
//            break
//        default:
            Function.Message("Info", message: "Comming soon")
           // break
       // }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath as IndexPath) as! cellMenu
        cell.lbMenu.text = arrMenu[indexPath.row]
        
        cell.imgMenu.image = UIImage(named: arrImg[indexPath.row])
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
