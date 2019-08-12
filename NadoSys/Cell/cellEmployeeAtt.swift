//
//  cellEmployeeAtt.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 8/12/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class cellEmployeeAtt: UITableViewCell {

    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var employeeName: UILabel!
    var strDay = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        collecView.delegate = self
        collecView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension cellEmployeeAtt: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func updateUI(){
        collecView.reloadData()
    }
    //    func clearUI(){
    //        collecView.clear
    //    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (strDay.count)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecView.dequeueReusableCell(withReuseIdentifier: "collecEmpAtt", for: indexPath) as! collecEmpAtt
        cell.labelDay.setBorder(radius: 6, color: UIColor(netHex: 0x1966a7))
        cell.labelDay.text = strDay[indexPath.row]
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}


