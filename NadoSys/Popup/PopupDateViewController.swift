//
//  PopupDateViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/16/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol selectDateDelegate {
    func returnDate(week: Int,month: Int,year: Int,type: String)
}
class PopupDateViewController: UIViewController {
    
    @IBOutlet weak var labelDate: UILabel!
    var _type = ""
    var _rowSelect = 0
    var delegate: selectDateDelegate?
    var weeks = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","48","50","51","52"]
    @IBOutlet weak var viewPopup: UIView!
    var months = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    var years = ["2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027"]
    @IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        showAnimate()
        labelDate.text = _type == "WEEKLY" ? "Select Week":"Select Month"
        if _type == "WEEKLY" {
            _rowSelect = Date().week() - 1
        }
        else{
            _rowSelect = Date().month() - 1
        }
        let rowSelectYear = 4
        picker.selectRow(_rowSelect, inComponent: 0, animated: true)
        picker.selectRow(rowSelectYear, inComponent: 1, animated: true)
        // Do any additional setup after loading the view.
    }
    func updateUI(){
        viewPopup.layer.cornerRadius = 15
        viewPopup.layer.borderWidth = 1
    }
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.9
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

    @IBAction func onOK(_ sender: Any) {
        if _type == "WEEKLY"{
            delegate?.returnDate(week: Int(weeks[picker.selectedRow(inComponent: 0)])!, month: 0, year: Int(years[picker.selectedRow(inComponent: 1)])!, type: _type)
        }
        else{
             delegate?.returnDate(week: 0, month: Int(months[picker.selectedRow(inComponent: 0)])!, year: Int(years[picker.selectedRow(inComponent: 1)])!, type: _type)
        }
        removeAnimate()
        
    }
    @IBAction func onClose(_ sender: Any) {
        removeAnimate()
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
extension PopupDateViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            if _type == "WEEKLY"{
                return weeks.count
            }
            return months.count
        }
            
        else {
            return years.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if _type == "WEEKLY"{
                return weeks[row]
            }
           return months[row]
            
        } else {
            
            return years[row]
        }
    }
    
}
