//
//  SellOutReportViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/15/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class SellOutReportViewController: UIViewController {

    var _fromDate = ""
    var _toDate = ""
    var _month = 0
    var _week = 0
    var _year = 0
    var _date = ""
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
        _week = Date().week()
        _year = Date().year()
        _month = Date().month()
        _date = Date().toShortTimeString()
        labelDate.text = "Date: \(_month)-\(_year)"
        _fromDate = Function.firstDay(ofMonth: Date().month(), year: Date().year()).toShortTimeString()
        _toDate = Function.lastDay(ofMonth: Date().month(), year: Date().year()).toShortTimeString()
        loaddata(_fromDate,toDate: _toDate)
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
        labelDate.text = "Date: \(_date)"
        loaddata(_date, toDate: _date)
    }
    @IBAction func onWeekly(_ sender: Any) {
        btnDaily.titleLabel?.textColor = UIColor.black
        btnWeekly.setTitleColor(.white, for: .normal)
        btnMonthly.titleLabel?.textColor = UIColor.black
        btnDaily.backgroundColor = UIColor.white
        btnWeekly.backgroundColor = UIColor(netHex: 0x3E79A6)
        btnMonthly.backgroundColor = UIColor.white
        _type = "WEEKLY"
        labelDate.text = "Week: \(_week)-\(_year)"
        let gregorian = Calendar(identifier: .gregorian)
        let fromDate = Function.firstDay(ofWeek: _week, year: _year)
        let toDate = gregorian.date(byAdding: .day, value: 6, to: fromDate)
        loaddata(_fromDate, toDate: _toDate)
    }
    @IBAction func onMonthly(_ sender: Any) {
        btnDaily.titleLabel?.textColor = UIColor.black
        btnWeekly.titleLabel?.textColor = UIColor.black
        btnMonthly.setTitleColor(.white, for: .normal)
        btnDaily.backgroundColor = UIColor.white
        btnWeekly.backgroundColor = UIColor.white
        btnMonthly.backgroundColor = UIColor(netHex: 0x3E79A6)
        _type = "MONTHLY"
        labelDate.text = "Month: \(_month)-\(_year)"
        _fromDate = Function.firstDay(ofMonth: _month, year: _year).toShortTimeString()
        _toDate = Function.lastDay(ofMonth: _month, year: _year).toShortTimeString()
        loaddata(_fromDate, toDate: _toDate)
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
        let controller = storyboard?.instantiateViewController(withIdentifier:"frmSellOutDetail") as! SellOutReportDetailViewController
        controller._sellout = _lstReport[indexPath.row]
        controller._fromDate = _fromDate
        controller._toDate = _toDate
        controller._type = _type
        controller._month = _month
        controller._date = _date
        controller._week = _week
        controller._year = _year
        if let viewController = self.navigationController{
            viewController.pushViewController(controller, animated: true)
        }
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
         _fromDate = date.toShortTimeString()
         _toDate = date.toShortTimeString()
         loaddata(_fromDate, toDate: _toDate)
         _date = date.toShortTimeString()
         labelDate.text = "Date: \(_date)"
    }
}
extension SellOutReportViewController: selectDateDelegate{
    func returnDate(week: Int, month: Int, year: Int, type: String) {
        if type == "MONTHLY"{
            _fromDate = Function.firstDay(ofMonth: month, year: year).toShortTimeString()
            _toDate = Function.lastDay(ofMonth: month, year: year).toShortTimeString()
            loaddata(_fromDate, toDate: _toDate)
            _year = year
            _month = month
            labelDate.text = "Month: \(month)-\(year)"
        }
        else if type == "WEEKLY"{
            let gregorian = Calendar(identifier: .gregorian)
            let fromDate = Function.firstDay(ofWeek: week, year: year)
            let toDate = gregorian.date(byAdding: .day, value: 6, to: fromDate)
            _fromDate = fromDate.toShortTimeString()
            _toDate = (toDate?.toShortTimeString())!
            _week = week
            _year = year
            labelDate.text = "Week: \(week)-\(year)"
            loaddata(_fromDate, toDate: _toDate)
        }
    }
}
