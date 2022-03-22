//
//  ItemCollectionViewCell.swift
//  FlickrSearchApp
//
//  Created by Amir Bakhshi on 2022-03-19.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    static let identifier = "ItemCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
    
}
