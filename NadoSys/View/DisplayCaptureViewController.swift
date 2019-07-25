//
//  DisplayCaptureViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/10/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class DisplayCaptureViewController: BaseViewController,cameraProtocol {
   
    var _dataOfflineController: IDataOffline!
    var _displayController: IDisplay!
    var pageViewController : UIPageViewController!
    var arrCompetitor: [ObjectDataModel] = []
    var _login = Defaults.getUser(key: "LOGIN")
    var _shopId = Int(Preferences.get(key: "SHOPID"))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageViewController     = self.storyboard?.instantiateViewController(withIdentifier: "displayPaging") as! UIPageViewController
        self.pageViewController.dataSource = self
        loadData()
        addRightButton()
        // Do any additional setup after loading the view.
    }
    
    func addRightButton(){
        //self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title:"Display Capture/Trưng bày", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem!.backBarButtonItem =
            UIBarButtonItem(title:"NDS", style:.plain, target:nil, action:nil)
    }
    
    func loadData(){
        arrCompetitor = _dataOfflineController.GetListObjectDatas("Compertitor")!
        if arrCompetitor !=  nil && arrCompetitor.count > 0 {
            self.initPageViewControl()
        }
    }

    func initPageViewControl(){
        let startVC = self.viewControllerAtIndex(0) as! DisplayMainItemViewController
        let viewControllers = [startVC]
        self.pageViewController.setViewControllers(viewControllers, direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: self.view.frame.size.height)
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
    }
    
    func viewControllerAtIndex(_ index : Int) -> UIViewController {
        if self.arrCompetitor.count == 0 || index >= self.arrCompetitor.count {
            return DisplayMainItemViewController()
        }
      
        if index > 0{
            let vc: DisplayItemViewController = self.storyboard?.instantiateViewController(withIdentifier: "frmItemDisplay") as! DisplayItemViewController
            //navigationItem.title = self.arrCompetitor[index].objectName
            if vc.arrCategory != nil{
                vc.lbTitle = arrCompetitor[index].objectName
                vc.arrCategory = _displayController.getCategoryByCompetitor(arrCompetitor[index].objectId, shopId: _shopId!, empId: (_login?.employeeId)!)
                vc.pageIndex = index
                vc._competitorId = arrCompetitor[index].objectId
            }
            
            return vc
        }
        else{
            let vc: DisplayMainItemViewController = self.storyboard?.instantiateViewController(withIdentifier: "frmAquaDisplay") as! DisplayMainItemViewController
            //navigationItem.title = self.arrCompetitor[index].objectName
            if vc.arrModel != nil{
                vc.lbTitle = arrCompetitor[index].objectName
                vc.arrModel = _displayController.getModelByCompetitor(_shopId!, empId: (_login?.employeeId)!,competitorId: arrCompetitor[index].objectId)
                setGroupByCateCode(vc.arrModel!)
                vc.pageIndex = index
                vc.competitoId = arrCompetitor[index].objectId
            }
             //vc.pageIndex = index
            return vc
        }
        
        
    }
    
    func setGroupByCateCode(_ arrModel: [DisplayModel]){
        var headerGroup: String = ""
        for p in arrModel {
            
            if(headerGroup.contains(p.categoryCode)){
                continue
            }
            else{
                headerGroup += p.categoryCode + ";"
                p.groupBy = p.categoryCode
            }
            
        }
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
extension DisplayCaptureViewController: UIPageViewControllerDataSource{
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
         return arrCompetitor.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = 0
        if viewController.isKind(of: DisplayMainItemViewController.self) {
            let vc = viewController as! DisplayMainItemViewController
            index = vc.pageIndex
        }
        else{
            let vc = viewController as! DisplayItemViewController
            index = vc.pageIndex
        }
        //var index = vc.pageIndex as Int
        if (index == 0 || index == NSNotFound)
        {
            return nil
        }
        index -= 1
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = 0
        if viewController.isKind(of: DisplayMainItemViewController.self) {
            let vc = viewController as! DisplayMainItemViewController
            index = vc.pageIndex
        }
        else{
            let vc = viewController as! DisplayItemViewController
            index = vc.pageIndex
        }
        if (index == NSNotFound){
            return nil
        }
        index += 1
        if index == self.arrCompetitor.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    
    
    func ditReceiveImageUrl(imgUrl: String, imgName: String, imgData: Data, imgType: String, comment: String, latitude: Double, longitude: Double) {
        
    }
    
    

}
