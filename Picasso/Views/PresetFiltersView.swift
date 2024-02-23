//
//  PresetFiltersView.swift
//  Picasso
//
//  Created by Pavel Gribachev on 23.02.2024.
//

import UIKit

final class PresetFiltersView: UIView {

    @IBOutlet var presetFiltersViews: [UIView]!
    
    @IBOutlet var presetFiltersImageView: [UIImageView]!
    @IBOutlet var presetFiltersLabels: [UILabel]!
    
    let cornerRadius: CGFloat = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        setupPFView()
        
    }
    
    func setupPFView() {
        // view - cornerRadius
        presetFiltersViews.forEach { $0.layer.cornerRadius = 10 }
        presetFiltersViews.forEach { $0.backgroundColor = .clear }
        
        
        // imageView - contentMode
        presetFiltersImageView.forEach{ $0.contentMode = .scaleAspectFill }
        presetFiltersImageView.forEach{ $0.alpha = 0.5 }
    }
}
