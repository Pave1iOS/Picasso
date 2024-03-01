//
//  FilterView.swift
//  Picasso
//
//  Created by Pavel Gribachev on 25.02.2024.
//

import UIKit

final class FilterView: UIView {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        //imageView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.alpha = 0.5
        
        //view
        backView.backgroundColor = .clear
    }

}
