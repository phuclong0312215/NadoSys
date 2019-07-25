//
//  cellPosm.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/20/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegatePosm {
    func cal(for cell: cellPosm,size: Int)
    func remove(for cell: cellPosm)
}
class cellPosm: UITableViewCell {
    @IBOutlet weak var btnDecrease: UIButton!
    @IBOutlet weak var btnIncrease: UIButton!
    var _delegate: delegatePosm?
    @IBOutlet weak var posmName: UILabel!
    @IBOutlet weak var posmCode: UILabel!
    @IBOutlet weak var labeQty: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func decrease(_ sender: Any) {
        _delegate?.cal(for: self, size: -1)
    }
    @IBAction func increase(_ sender: Any) {
        _delegate?.cal(for: self, size: 1)
    }
    
    @IBAction func remove(_ sender: Any) {
        _delegate?.remove(for: self)
    }
}
