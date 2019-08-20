//
//  DashboardViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/8/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import ACTabScrollView
class DashboardViewController: UIViewController {
    var contentViews = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabScrollView.delegate = self
        tabScrollView.dataSource = self
        tabScrollView.defaultPage = 1
        tabScrollView.arrowIndicator = true
        tabScrollView.tabSectionHeight = 50
        tabScrollView.tabSectionBackgroundColor = UIColor.white
        tabScrollView.contentSectionBackgroundColor = UIColor.white
        tabScrollView.tabGradient = true
        tabScrollView.pagingEnabled = true
        tabScrollView.cachedPageLimit = 3
       
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "frmPOSMRelease") as! POSMViewController
      
        addChild(vc) // don't forget, it's very important
        contentViews.append(vc.view)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "frmCreatePOSM") as! CreatePOSMViewController
        contentViews.append(vc1.view)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var tabScrollView: ACTabScrollView!
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension DashboardViewController: ACTabScrollViewDataSource,ACTabScrollViewDelegate{
    // MARK: ACTabScrollViewDelegate
    func tabScrollView(_ tabScrollView: ACTabScrollView, didChangePageTo index: Int) {
        
    }
    func tabScrollView(_ tabScrollView: ACTabScrollView, didScrollPageTo index: Int) {
        
    }
    
    // MARK: ACTabScrollViewDataSource
    func numberOfPagesInTabScrollView(_ tabScrollView: ACTabScrollView) -> Int {
        return contentViews.count
    }
    func tabScrollView(_ tabScrollView: ACTabScrollView, tabViewForPageAtIndex index: Int) -> UIView {
        // create a label
        let label = UILabel()
        label.text = String(describing: DashboardCategory.allValues()[index]).uppercased()
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)
        } else {
            label.font = UIFont.systemFont(ofSize: 16)
        }
        label.textColor = UIColor(red: 77.0 / 255, green: 79.0 / 255, blue: 84.0 / 255, alpha: 1)
        label.textAlignment = .center
        
        // if the size of your tab is not fixed, you can adjust the size by the following way.
        label.sizeToFit() // resize the label to the size of content
        label.frame.size = CGSize(width: label.frame.size.width + 28, height: label.frame.size.height + 36) // add some paddings
        
        return label
    }
    
    func tabScrollView(_ tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
        return contentViews[index]
    }
    
}
enum DashboardCategory {
    case Summary
    case SellAnalytics
    static func allValues() -> [DashboardCategory] {
        return [.Summary, .SellAnalytics]
    }
}
