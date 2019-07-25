//
//  cellModelDisplay.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/10/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegateDisplay {
    func cal(for cell: cellModelDisplay,size: Int)
    func cal(for cell: cellSellout,size: Int)
    func remove(for cell: cellSellout)
}
extension delegateDisplay{
    func cal(for cell: cellModelDisplay,size: Int){}
    func cal(for cell: cellSellout,size: Int){}
    func remove(for cell: cellSellout){}
}
class cellModelDisplay: UITableViewCell {

    @IBOutlet weak var btnDecrease: UIButton!
    @IBOutlet weak var btnIncrease: UIButton!
    @IBOutlet weak var viewCate: UIView!
    @IBOutlet weak var contrainHeight: NSLayoutConstraint!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var statulGuideline: UILabel!
    @IBOutlet weak var labelGuideline: UILabel!
    @IBOutlet weak var imgGuideline: UIImageView!
    @IBOutlet weak var labelCate: UILabel!
    @IBOutlet weak var labelModel: UILabel!
    @IBOutlet weak var btnCate: UIButton!
    var delegate: delegateDisplay?
    override func awakeFromNib() {
        super.awakeFromNib()
        btnDecrease.setRounded(radius: 6)
        btnIncrease.setRounded(radius: 6)
        txtValue.setBorder(radius: 0, color: UIColor(netHex: 0xD6D6D6))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func decrease(_ sender: Any) {
        delegate?.cal(for: self,size: -1)
    }
    @IBAction func increase(_ sender: Any) {
        delegate?.cal(for: self,size: 1)
    }
}
