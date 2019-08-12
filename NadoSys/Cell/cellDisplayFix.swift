//
//  cellDisplayFix.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/12/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class cellDisplayFix: UITableViewCell {

    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var labelPosm: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
