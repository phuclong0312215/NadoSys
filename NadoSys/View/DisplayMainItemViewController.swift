//
//  DisplayMainItemViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/12/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class DisplayMainItemViewController: UIViewController {
    var arrModel: [DisplayModel]? = []
    @IBOutlet weak var labelCompetitor: UILabel!
    var pageIndex: Int! = 0
    var lbTitle: String = ""
    var competitoId: Int = 0
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "frmMainDisplay")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "frmMainPhoto")
        
        return secondChildTabVC
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        labelCompetitor.text = lbTitle
        segmentControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        // Do any additional setup after loading the view.
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
            let vc = firstChildTabVC as! DisplayDataViewController
            vc.arrModel = self.arrModel
            vc.arrFilter = self.arrModel
            return vc
        case TabIndex.secondChildTab.rawValue :
            let vc = secondChildTabVC as! DisplayPhotoViewController
            vc._competitorId = self.competitoId
            return vc
        default:
            return nil
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
