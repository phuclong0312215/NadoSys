//
//  PopupCalendarViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/18/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import CVCalendar
protocol selectCalendarDelegate {
    func returnDate(_ date: Date)
}
class PopupCalendarViewController: UIViewController {
    private var animationFinished = true
    var _delegate: selectCalendarDelegate?
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarVIew: CVCalendarView!
    @IBOutlet weak var viewPopup: UIView!
    private var currentCalendar: Calendar?
    
    override func awakeFromNib() {
       currentCalendar = Calendar.current
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentCalendar = currentCalendar {
            monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
        
//        self.menuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 0, width: 300, height: 15))
//        self.calendarVIew = CVCalendarView(frame: CGRect(x: 0, y: 20, width: 300, height: 450))
        // Appearance delegate [Unnecessary]
       // self.calendarVIew.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
       // self.calendarVIew.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarVIew.calendarDelegate = self
       // updateUI()
        showAnimate()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menuView.commitMenuViewUpdate()
        self.calendarVIew.commitCalendarViewUpdate()
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

    @IBAction func onClose(_ sender: Any) {
        removeAnimate()
    }
    @IBAction func onOK(_ sender: Any) {
        _delegate?.returnDate(calendarVIew.presentedDate.convertedDate()!)
        removeAnimate()
    }
    @IBAction func preMonth(_ sender: Any) {
        calendarVIew.loadPreviousView()
    }
    @IBAction func nextMonth(_ sender: Any) {
        calendarVIew.loadNextView()
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
extension PopupCalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .sunday
    }
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
}
