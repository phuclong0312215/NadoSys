//
//  cellSellOutReport.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/15/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class cellSellOutReport: UITableViewCell {

    @IBOutlet weak var labelPercent: UILabel!
    @IBOutlet weak var labelActual: UILabel!
    @IBOutlet weak var labelTarget: UILabel!
    @IBOutlet weak var labelShopName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
