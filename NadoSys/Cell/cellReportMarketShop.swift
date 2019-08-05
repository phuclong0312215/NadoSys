//
//  cellReportMarketShop.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/5/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class cellReportMarketShop: UITableViewCell {

    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelNumOfME: UILabel!
    @IBOutlet weak var labelNumOfPs: UILabel!
    @IBOutlet weak var labelNumOfStore: UILabel!
    @IBOutlet weak var labelShop: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
