//
//  cellSellOutReportDetail.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/21/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
import SwiftyJSON
class cellSellOutReportDetail: UITableViewCell {

    var items = JSON()
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelSaleDate: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        myTable.delegate = self
        myTable.dataSource = self
        // Initialization code
    }
    @IBOutlet weak var lableName: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension cellSellOutReportDetail: UITableViewDelegate,UITableViewDataSource{
    func updateTableView(){
        myTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSellOutCustomer", for: indexPath) as! cellSellOutCustomer
        cell.labelModel.text = items[indexPath.row]["model"].stringValue
        cell.labelQty.text = items[indexPath.row]["quantity"].stringValue
        cell.labelCate.text = items[indexPath.row]["categoryCode"].stringValue
        
        var numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let price = items[indexPath.row]["price"].doubleValue
        let labelPrice = numberFormatter.string(from: NSNumber(value: price))
        cell.labelPrice.text = "\(labelPrice!)"
        let qty = items[indexPath.row]["quantity"].intValue
       
        let total = Double(exactly: qty)! * price
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let labelTotalPrice = numberFormatter.string(from: NSNumber(value: total))
        cell.labelTotalPrice.text = "\(qty) x \(labelPrice!) = \(labelTotalPrice!)"
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
}
