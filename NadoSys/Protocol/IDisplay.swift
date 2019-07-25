//
//  IDisplay.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/10/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import Foundation
protocol IDisplay {
    func getCategoryByCompetitor(_ competitorId: Int,shopId: Int,empId: Int) -> [DisplayModel]?
    func getModelByCompetitor(_ shopId: Int,empId: Int,competitorId: Int) -> [DisplayModel]?
    func save(_ model: DisplayModel,type: String)
}


