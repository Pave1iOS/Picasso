//
//  ImageItemCollectionView.swift
//  Picasso
//
//  Created by Pavel Gribachev on 23.02.2024.
//

import UIKit
import Kingfisher

final class ImageItemCollectionView: UICollectionViewCell {
    @IBOutlet weak var imageItemCV: UIImageView! {
        didSet {
            imageItemCV.layer.cornerRadius = 10
            imageItemCV.contentMode = .scaleAspectFill
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
   
    }
    
    func configure(with picasso: Picasso) {
        
        let imageURL = URL(string: picasso.urls.small)
        let processor = DownsamplingImageProcessor(size: imageItemCV.bounds.size)
        
        imageItemCV.kf.indicatorType = .activity
        imageItemCV.kf.setImage(with: imageURL, options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
    }
    
}
