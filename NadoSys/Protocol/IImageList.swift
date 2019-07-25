//
//  IImageList.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/15/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
protocol IImageList {
    func GetLists(_ competitorId: Int,shopId: Int,reportDate: Int,imageType: Int,empId: Int,categoryCode: String) -> [ImageListModel]?
    func GetListUploads(_ competitorId: Int,shopId: Int,reportDate: Int,imageType: Int,empId: Int) -> [ImageListModel]? 
    func Insert(_ model: ImageListModel,completionHandler: @escaping (Bool?) -> ())
    func GetListSellOut(_ productguid: String) -> [ImageListModel]?
    func InsertList(_ list: [ImageListModel]) 
}

