//
//  cellAquaImageDisplay.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/15/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol delegateImageDisplay {
    func takephoto(for cell: cellAquaImageDisplay)
    func takephoto(for cell: cellSellout)
}
extension delegateImageDisplay{
    func takephoto(for cell: cellAquaImageDisplay){}
    func takephoto(for cell: cellSellout){}
}
class cellAquaImageDisplay: UITableViewCell {
    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var labelBrand: UILabel!
    
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelBarcode: UILabel!
    @IBOutlet weak var labelModel: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var buttonCate: UIButton!
    var _delegate: delegateImageDisplay?
    var _imageList: [ImageListModel]?
    override func awakeFromNib() {
        super.awakeFromNib()
        collecView.delegate = self
        collecView.dataSource = self
        // Initialization code
    }

    @IBAction func takePhoto(_ sender: Any) {
        _delegate?.takephoto(for: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension cellAquaImageDisplay: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func updateUI(){
        collecView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (_imageList!.count)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecView.dequeueReusableCell(withReuseIdentifier: "collectImageCell", for: indexPath) as! collectImageCell
        fetchImage(urlImage: _imageList![indexPath.row].urlimage, imgView: cell.imageView )
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

