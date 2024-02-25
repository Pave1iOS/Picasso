//
//  ImageItemCollectionView.swift
//  Picasso
//
//  Created by Pavel Gribachev on 23.02.2024.
//

import UIKit
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
        let imageURL = URL(string: picasso.urls.regular)
        
        imageItemCV.af.setImage(withURL: imageURL!, placeholderImage: UIImage(named: "LSIcon"), completion:  { response in
            switch response.result {
                
            case .success(_):
                print("succes, image download")
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        
    }
    
}
