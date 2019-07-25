//
//  IPromotion.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/18/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
protocol IPromotion{
    func InsertPromotionImage(_ model: PromotionImageModel,completionHandler: @escaping (Bool?) -> ())
    func InsertPromotion(_ model: PromotionModel)
    func GetList(_ shopId: Int,reportDate: String,empId: Int) -> [PromotionModel]?
    func GetListImages(_ shopId: Int,reportDate: String,empId: Int,guid: String) -> [PromotionImageModel]?
    func GetImageList(_ shopId: Int,reportDate: String,empId: Int,guid: String) -> [ImageListModel]? 
}
