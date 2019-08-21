//
//  cellSellOutCustomer.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/21/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class cellSellOutCustomer: UITableViewCell {

    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelCate: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var labelModel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
