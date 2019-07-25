//
//  Swinject.swift
//  HiProject
//
//  Created by Nguyen Phuc Long on 4/15/18.
//  Copyright © 2018 PHUCLONG. All rights reserved.
//

import Foundation
import SwinjectStoryboard
import Swinject
extension SwinjectStoryboard
{
//    class func getCustomClass() -> IDataOffline {
//        return defaultContainer.resolve(IDataOffline.self)!
//    }
    class func setup ()
    {
        defaultContainer.register(ILogin.self) { resolveable in
            return LoginController()
        }
        defaultContainer.register(IDisplay.self) { resolveable in
            return DisplayController(dataOfflineController: resolveable.resolve(IDataOffline.self)!)
        }
        defaultContainer.register(ISellOut.self) { resolveable in
            return SellOutController(dataOfflineController: resolveable.resolve(IDataOffline.self)!)
        }
        defaultContainer.register(IImageList.self) { resolveable in
            return ImageListController(dataOfflineController: resolveable.resolve(IDataOffline.self)!)
        }
        defaultContainer.register(IDataOffline.self) { resolveable in
            return DataOfflineController()
        }
        defaultContainer.register(IDataOnline.self) { resolveable in
            return DataOnlineController()
        }
        defaultContainer.register(IPromotion.self) { resolveable in
            return PromotionController()
        }
        defaultContainer.register(IDisplayStand.self) { resolveable in
            return DisplayStandController()
        }
        defaultContainer.register(IAttandance.self) { resolveable in
            return AttandanceController()
        }
        defaultContainer.storyboardInitCompleted(CheckInViewController.self) {
            resolveable, viewController in
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
            viewController._attandanceController = resolveable.resolve(IAttandance.self)
        }
        defaultContainer.storyboardInitCompleted(ViewController.self) {
            resolveable, viewController in
            viewController._loginController = resolveable.resolve(ILogin.self)
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
        }
        defaultContainer.storyboardInitCompleted(ShopViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
        }
        defaultContainer.storyboardInitCompleted(KPIViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
            viewController._attandanceController = resolveable.resolve(IAttandance.self)
        }
        defaultContainer.storyboardInitCompleted(DisplayCaptureViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
            viewController._displayController = resolveable.resolve(IDisplay.self)
        }
        defaultContainer.storyboardInitCompleted(DisplayItemViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
            viewController._imageListController = resolveable.resolve(IImageList.self)
            viewController._displayController = resolveable.resolve(IDisplay.self)
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
        }
        defaultContainer.storyboardInitCompleted(DisplayMainItemViewController.self) {
            resolveable, viewController in
            
        }
        defaultContainer.storyboardInitCompleted(DisplayDataViewController.self) {
            resolveable, viewController in
             viewController._displayController = resolveable.resolve(IDisplay.self)
             viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
        }
        
        defaultContainer.storyboardInitCompleted(DisplayPhotoViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
            viewController._imageListController = resolveable.resolve(IImageList.self)
        }
        
        defaultContainer.storyboardInitCompleted(ModelListViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
        }
        defaultContainer.storyboardInitCompleted(CreateCollectViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
            viewController._promotionController = resolveable.resolve(IPromotion.self)
        }
        defaultContainer.storyboardInitCompleted(ObjectDataListViewController.self) {
            resolveable, viewController in
            
        }
        defaultContainer.storyboardInitCompleted(CollectDataViewController.self) {
            resolveable, viewController in
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
            viewController._promotionController = resolveable.resolve(IPromotion.self)
        }
        defaultContainer.storyboardInitCompleted(CreateDisplayStandViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
            viewController._displayStandController = resolveable.resolve(IDisplayStand.self)
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
        }
        defaultContainer.storyboardInitCompleted(DisplayStandViewController.self) {
            resolveable, viewController in
            viewController._displayStandController = resolveable.resolve(IDisplayStand.self)
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
        }
        defaultContainer.storyboardInitCompleted(CreateSellOutViewController.self) {
            resolveable, viewController in
           viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
            viewController._imageListController = resolveable.resolve(IImageList.self)
            viewController._sellOutController = resolveable.resolve(ISellOut.self)
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
        }
        defaultContainer.storyboardInitCompleted(SellOutViewController.self) {
            resolveable, viewController in
            viewController._sellOutController = resolveable.resolve(ISellOut.self)
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
        }
        defaultContainer.storyboardInitCompleted(ModelListSellOutViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
            viewController._sellOutController = resolveable.resolve(ISellOut.self)
        }
        defaultContainer.storyboardInitCompleted(ShopProfileViewController.self) {
            resolveable, viewController in
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
        }
        defaultContainer.storyboardInitCompleted(SupplierListViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
        }
        defaultContainer.storyboardInitCompleted(MainViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
        }
        defaultContainer.storyboardInitCompleted(MenuViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
        }
        defaultContainer.storyboardInitCompleted(UpdateShopViewController.self) {
            resolveable, viewController in
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
        }
        defaultContainer.storyboardInitCompleted(LocationViewController.self) {
            resolveable, viewController in
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
        }
        defaultContainer.storyboardInitCompleted(POSMViewController.self) {
            resolveable, viewController in
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
        }
        defaultContainer.storyboardInitCompleted(CreatePOSMViewController.self) {
            resolveable, viewController in
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
        }
        defaultContainer.storyboardInitCompleted(POSMListSelectViewController.self) {
            resolveable, viewController in
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
        }
        defaultContainer.storyboardInitCompleted(POSMImageViewController.self) {
            resolveable, viewController in
            viewController._dataOnlineController = resolveable.resolve(IDataOnline.self)
            viewController._dataOfflineController = resolveable.resolve(IDataOffline.self)
            viewController._imageListController = resolveable.resolve(IImageList.self)
        }
    }
   
}
