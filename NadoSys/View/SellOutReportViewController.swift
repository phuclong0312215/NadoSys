//
//  SellOutReportViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/15/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class SellOutReportViewController: UIViewController {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelAchievement: UILabel!
    @IBOutlet weak var labelActual: UILabel!
    @IBOutlet weak var labelTarget: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var btnDaily: UIButton!
    @IBOutlet weak var btnMonthly: UIButton!
    @IBOutlet weak var btnWeekly: UIButton!
    @IBOutlet weak var myTable: UITableView!
    var _type = "MONTHLY"
    var _lstReport = [SellOutReportModel]()
    var _dataOnlineController: IDataOnline!
    var _login = Defaults.getUser(key: "LOGIN")
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        labelDate.text = "Date: \(Date().month())-\(Date().year())"
        let fromDate = Function.firstDay(ofMonth: Date().month(), year: Date().year()).toShortTimeString()
        let toDate = Function.lastDay(ofMonth: Date().month(), year: Date().year()).toShortTimeString()
        loaddata(fromDate,toDate: toDate)
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }
    func loaddata(_ fromDate: String,toDate: String){
        SVProgressHUD.show()
        _dataOnlineController.GetSellOutReport((_login?.employeeId)!, fromDate: fromDate,toDate: toDate) { (data, error) in
            if data != nil{
                if (data?.count)! > 0 {
                    self._lstReport = data!
                    let dataTotal = self._lstReport.remove(at: 0)
                    self.labelTarget.text = String(dataTotal.target).toTarget()
                    self.labelActual.text = String(dataTotal.amount).toTarget()
                    self.labelAchievement.text = "\(dataTotal.per) %"
                }
               
            }
            else{
                self._lstReport = [SellOutReportModel]()
                self.labelTarget.text = "0"
                self.labelActual.text = "0"
                self.labelAchievement.text = "0 %"
            }
            self.updateTableView()
            SVProgressHUD.dismiss()
        
        }
    }
    @IBAction func onDaily(_ sender: Any) {
        btnDaily.setTitleColor(.white, for: .normal)
        btnWeekly.titleLabel?.textColor = UIColor.black
        btnMonthly.titleLabel?.textColor = UIColor.black
        btnDaily.backgroundColor = UIColor(netHex: 0x3E79A6)
        btnWeekly.backgroundColor = UIColor.white
        btnMonthly.backgroundColor = UIColor.white
        _type = "DAILY"
        labelDate.text = "Date: \(Date().toShortTimeString())"
    }
    @IBAction func onWeekly(_ sender: Any) {
        btnDaily.titleLabel?.textColor = UIColor.black
        btnWeekly.setTitleColor(.white, for: .normal)
        btnMonthly.titleLabel?.textColor = UIColor.black
        btnDaily.backgroundColor = UIColor.white
        btnWeekly.backgroundColor = UIColor(netHex: 0x3E79A6)
        btnMonthly.backgroundColor = UIColor.white
        _type = "WEEKLY"
        labelDate.text = "Date: \(Date().week())-\(Date().year())"
    }
    @IBAction func onMonthly(_ sender: Any) {
        btnDaily.titleLabel?.textColor = UIColor.black
        btnWeekly.titleLabel?.textColor = UIColor.black
        btnMonthly.setTitleColor(.white, for: .normal)
        btnDaily.backgroundColor = UIColor.white
        btnWeekly.backgroundColor = UIColor.white
        btnMonthly.backgroundColor = UIColor(netHex: 0x3E79A6)
        _type = "MONTHLY"
        labelDate.text = "Date: \(Date().month())-\(Date().year())"
    }
    
    @IBAction func onfilterDate(_ sender: Any) {
        if _type == "DAILY"{
            let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupCalendar") as! PopupCalendarViewController
            self.addChild(popup)
            popup._delegate = self
            popup.view.frame = self.view.frame
            self.view.addSubview(popup.view)
            popup.didMove(toParent: self)

            
        }
        else{
            let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupDate") as! PopupDateViewController
            self.addChild(popup)
            popup.delegate = self
            popup._type = _type
            popup.view.frame = self.view.frame
            self.view.addSubview(popup.view)
            popup.didMove(toParent: self)

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
extension SellOutReportViewController: UITableViewDelegate,UITableViewDataSource{
    func updateTableView(){
        myTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lstReport.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 53
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushViewController(withIdentifier: "frmSellOutDetail")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSellOutReport", for: indexPath) as! cellSellOutReport
        cell.labelShopName.text = _lstReport[indexPath.row].shopName
        let target = "\(_lstReport[indexPath.row].target)"
        cell.labelTarget.text = target.toTarget()
        let actual =  "\(_lstReport[indexPath.row].amount)"
        cell.labelActual.text = actual.toTarget()
        cell.labelPercent.text = "\(_lstReport[indexPath.row].per) %"
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
}
extension SellOutReportViewController: selectCalendarDelegate{
    func returnDate(_ date: Date) {
         loaddata(date.toShortTimeString(), toDate: date.toShortTimeString())
    }
}
extension SellOutReportViewController: selectDateDelegate{
    func returnDate(week: Int, month: Int, year: Int, type: String) {
        if type == "MONTHLY"{
            let fromDate = Function.firstDay(ofMonth: month, year: year).toShortTimeString()
            let toDate = Function.lastDay(ofMonth: month, year: year).toShortTimeString()
            loaddata(fromDate, toDate: toDate)
        }
        else if type == "WEEKLY"{
            let gregorian = Calendar(identifier: .gregorian)
            let fromDate = Function.firstDay(ofWeek: week, year: year)
            let toDate = gregorian.date(byAdding: .day, value: 6, to: fromDate)
             //return
            loaddata(fromDate.toShortTimeString(), toDate: (toDate?.toShortTimeString())!)
        }
    }
}
