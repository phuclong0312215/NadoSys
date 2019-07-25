//
//  cellCateDisplay.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/10/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegateCateDisplay {
    func cal(for cell: cellCateDisplay,size: Int)
}
class cellCateDisplay: UITableViewCell {

    
    @IBOutlet weak var btnDecrease: UIButton!
    @IBOutlet weak var btnIncrease: UIButton!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var labelCate: UILabel!
    var delegate: delegateCateDisplay?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        btnDecrease.setBorder(radius: 6)
        btnIncrease.setBorder(radius: 6)
        txtValue.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        // Configure the view for the selected state
    }

    @IBAction func decrease(_ sender: Any) {
        delegate?.cal(for: self,size: -1)
    }
    @IBAction func increase(_ sender: Any) {
        delegate?.cal(for: self,size: 1)
    }
}
