//
//  IDisplayStand.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/19/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
protocol IDisplayStand{
    func InsertStandImage(_ model: DisplayStandImageModel,completionHandler: @escaping (Bool?) -> ())
    func InsertStand(_ model: DisplayStandModel)
    func GetList(_ shopId: Int,reportDate: String,empId: Int) -> [DisplayStandModel]?
     func GetImageList(_ shopId: Int, reportDate: String, posmId: Int,empId: Int) -> [ImageListModel]? 
}
