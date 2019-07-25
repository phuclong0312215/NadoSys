//
//  KPIViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/9/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class KPIViewController: UIViewController {
    var _dataOfflineController: IDataOffline!
    var _listKPIs = [KPIModel]()
    @IBOutlet weak var labelShopVisit: UILabel!
    @IBOutlet weak var labelShopName: UILabel!
    @IBOutlet weak var myCollection: UICollectionView!
    var _attandanceController: IAttandance!
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        myCollection.delegate = self
        myCollection.dataSource = self
        getKPIs()
        // Do any additional setup after loading the view.
    }
    func setNavigationBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x1966a7)
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func getKPIs(){
        _listKPIs = _dataOfflineController.GetListKPIs()!
        labelShopName.text = Preferences.get(key: "SHOPNAME")
        updateUI()
    }

    @IBAction func back(_ sender: Any) {
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
extension KPIViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func updateUI(){
        myCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (_listKPIs.count)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let function = _listKPIs[indexPath.row].id
        if function != 1 && function != 8{
            let attandance = _attandanceController.GetByType(_shopId!, empId: (_login?.employeeId)!, attandanceDate: Date().toShortTimeString(), aType: "IN")
            if attandance == nil {
                Function.Message("Thông báo", message: "Vui lòng chấm công vào trước khi thực hiện báo cáo này")
                return
            }
        }
        switch function {
        case 1:
            Preferences.put(key: "CHECKTYPE", value: "IN")
            pushViewController(withIdentifier: "frmCheckIn")
            break
        case 6:
            Preferences.put(key: "CHECKTYPE", value: "Out")
            pushViewController(withIdentifier: "frmCheckIn")
            break
        case 8:
           // pushViewController(withIdentifier: "frmShopProfile")
            pushViewController(withIdentifier: "frmUpdateShop")
            break
        case 4:
            pushViewController(withIdentifier: "frmDisplayCapture")
           // pushViewController(withIdentifier: "frmTabDisplay")
            break
        case 9:
            pushViewController(withIdentifier: "frmCollectData")
            break
        case 1011:
            pushViewController(withIdentifier: "frmDisplayStand")
            break
        case 2:
             Preferences.put(key: "SALETYPE", value: "SELLOUT")
            pushViewController(withIdentifier: "frmSellOut")
            break
        case 7:
            Preferences.put(key: "SALETYPE", value: "SELLIN")
            pushViewController(withIdentifier: "frmSellOut")
            break
        case 1008:
            Preferences.put(key: "SALETYPE", value: "STOCK")
            pushViewController(withIdentifier: "frmSellOut")
            break
        case 3:
            Preferences.put(key: "SALETYPE", value: "SELLTHROUGH")
            pushViewController(withIdentifier: "frmSellOut")
            break
        default:
            Preferences.put(key: "POSMTYPE", value: "RESULT")
            pushViewController(withIdentifier: "frmPOSMRelease")
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollection.dequeueReusableCell(withReuseIdentifier: "cellKPI", for: indexPath) as! cellKPI
        cell.imageKPI.image = UIImage(named: _listKPIs[indexPath.row].functionIcon)
        cell.labelKPI.text = _listKPIs[indexPath.row].functionName
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
extension KPIViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3 - 30
        let height : CGFloat = 116.0
        return CGSize(width: width, height: height)
    }
}
