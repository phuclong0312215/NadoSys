//
//  cellModelList.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/17/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class cellModelList: UITableViewCell {

    @IBOutlet weak var labelCountModel: UILabel!
    @IBOutlet weak var labelModel: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
