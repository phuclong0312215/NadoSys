//
//  IAttandance.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/24/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
protocol IAttandance{
     func GetByType(_ shopId: Int,empId: Int,attandanceDate: String,aType: String) -> AttandanceModel? 
     func InsertAttandance(_ model: AttandanceModel,completionHandler: @escaping (Bool?) -> ()) 
}

