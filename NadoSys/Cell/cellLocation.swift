//
//  cellLocation.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/19/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class cellLocation: UITableViewCell {
   
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
