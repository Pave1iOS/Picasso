//
//  ImageItemCollectionView.swift
//  Picasso
//
//  Created by Pavel Gribachev on 23.02.2024.
//

import UIKit
import Kingfisher
import AlamofireImage

final class ImageItemCollectionView: UICollectionViewCell {
    @IBOutlet weak var imageItemCV: UIImageView! {
        didSet {
            imageItemCV.layer.cornerRadius = 10
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
   
    }
    func configure(with picasso: Picasso) {
        
        let imageURL = URL(string: picasso.urls.small)
        let processor = DownsamplingImageProcessor(size: imageItemCV.bounds.size)
        
        imageItemCV.kf.indicatorType = .activity
        imageItemCV.kf.setImage(with: imageURL, placeholder: UIImage(named: "LSIcon"), options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
    }
    
}
