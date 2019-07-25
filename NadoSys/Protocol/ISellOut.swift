//
//  ISellOut.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/22/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
protocol ISellOut{
     func GetList(_ shopId: Int,empId: Int,saleDate: String,objId: Int) -> [SellOutModel]?
     func Insert(_ list: [SellOutModel])
}

