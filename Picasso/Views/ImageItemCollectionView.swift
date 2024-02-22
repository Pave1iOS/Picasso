//
//  ImageItemCollectionView.swift
//  Picasso
//
//  Created by Pavel Gribachev on 23.02.2024.
//

import UIKit

final class ImageItemCollectionView: UICollectionViewCell {
    @IBOutlet weak var imageItemCV: UIImageView! {
        didSet {
            imageItemCV.layer.cornerRadius = 10
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
            
    }
    
    
}
