//
//  RouterViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/23/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class RouterViewController: UIViewController {

    @IBOutlet weak var viewPOSM: UIView!
    @IBOutlet weak var viewRouter: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let doRouter = UITapGestureRecognizer(target: self, action:  #selector(self.DoRouter))
        self.viewRouter.addGestureRecognizer(doRouter)
        let doPOSM = UITapGestureRecognizer(target: self, action:  #selector(self.DoPOSM))
        self.viewPOSM.addGestureRecognizer(doPOSM)
        setNavigationBar()
        viewRouter.setBorder(radius: 4)
        viewPOSM.setBorder(radius: 4)
        // Do any additional setup after loading the view.
    }
    @objc func DoRouter(sender : UITapGestureRecognizer) {
        // Do what you want
        pushViewController(withIdentifier: "frmShop")
    }
    @objc func DoPOSM(sender : UITapGestureRecognizer) {
        // Do what you want
        Preferences.put(key: "POSMTYPE", value: "STOCK")
        pushViewController(withIdentifier: "frmPOSMRelease")
    }
    func setNavigationBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x1966a7)
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        addRightButton()
    }
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Welcome,Nhân viên thị trường", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title: "NDS", style:.plain, target:nil, action:nil)
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
