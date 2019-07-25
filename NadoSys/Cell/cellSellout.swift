//
//  cellSellout.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/22/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class cellSellout: UITableViewCell {
    @IBOutlet weak var heightViewModel: NSLayoutConstraint!
    
    @IBOutlet weak var imgPhoto: UIButton!
    @IBOutlet weak var viewSpace: UIView!
    @IBOutlet weak var heightView: NSLayoutConstraint!
    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelCate: UILabel!
    @IBOutlet weak var labelBarcode: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var labelModel: UILabel!
    @IBOutlet weak var txtModel: UITextField!
    var _delegate: delegateImageDisplay?
    var _delegateDisplay: delegateDisplay?
    var _imageList = [ImageListModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        collecView.delegate = self
        collecView.dataSource = self
        // Initialization code
    }

    @IBAction func increase(_ sender: Any) {
        _delegateDisplay?.cal(for: self, size: 1)
    }
    @IBAction func decrease(_ sender: Any) {
        _delegateDisplay?.cal(for: self, size: -1)
    }
    
    @IBAction func deleteSellOut(_ sender: Any) {
    }
    @IBAction func takePhoto(_ sender: Any) {
        _delegate?.takephoto(for: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func remove(_ sender: Any) {
        _delegateDisplay?.remove(for: self)
    }
}
extension cellSellout: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func updateUI(){
        collecView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (_imageList.count)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecView.dequeueReusableCell(withReuseIdentifier: "collectImageCell", for: indexPath) as! collectImageCell
        fetchImage(urlImage: _imageList[indexPath.row].urlimage, imgView: cell.imageView )
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func fetchImage(urlImage: String,imgView: UIImageView) {
        let imagePAth = Function.getDirectoryPath() + "/\(urlImage)"
        imgView.image = UIImage(contentsOfFile: imagePAth)
    }
}


