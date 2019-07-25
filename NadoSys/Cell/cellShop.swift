//
//  cellShop.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/8/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class cellShop: UITableViewCell {

   
    @IBOutlet weak var lbShopName: UILabel!
    
    @IBOutlet weak var lbShopCode: UILabel!
    
   
    @IBOutlet weak var lbShopAddress: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
