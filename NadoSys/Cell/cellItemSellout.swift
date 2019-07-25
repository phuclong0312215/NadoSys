//
//  cellItemSellout.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/4/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class cellItemSellout: UITableViewCell {

    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelCusName: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var labelModel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
         labelQty.setBorder(radius: 4)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
