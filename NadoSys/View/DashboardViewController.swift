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
        tabScrollView.defaultPage = 3
        tabScrollView.arrowIndicator = true
        tabScrollView.tabSectionHeight = 40
        tabScrollView.tabSectionBackgroundColor = UIColor.white
        tabScrollView.contentSectionBackgroundColor = UIColor.white
        tabScrollView.tabGradient = true
        tabScrollView.pagingEnabled = true
        tabScrollView.cachedPageLimit = 3
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor(red: 251/255, green: 252/255, blue: 149/255, alpha: 1.0)
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor(red: 252/255, green: 150/255, blue: 149/255, alpha: 1.0)
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor(red: 149/255, green: 218/255, blue: 252/255, alpha: 1.0)
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor(red: 149/255, green: 252/255, blue: 197/255, alpha: 1.0)
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor(red: 252/255, green: 182/255, blue: 106/255, alpha: 1.0)
        contentViews = [vc1.view,vc2.view,vc3.view,vc4.view,vc5.view]
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
    
    func tabScrollView(_ tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
        return contentViews[index]
    }
    func tabScrollView(_ tabScrollView: ACTabScrollView, tabViewForPageAtIndex index: Int) -> UIView {
        return contentViews[index]
    }
    
}
