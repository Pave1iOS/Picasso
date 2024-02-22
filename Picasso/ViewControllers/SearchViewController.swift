//
//  SearchViewController.swift
//  Picasso
//
//  Created by Pavel Gribachev on 22.02.2024.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTF: UITextField! {
        didSet {
            searchTF.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet var presetFiltersView: [UIView]! {
        didSet {
            presetFiltersView.forEach{ $0.layer.cornerRadius = cornerRadius }
        }
    }
    
    private let cornerRadius: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
    }
    
    

}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "imageItem", for: indexPath)
        
        return item
    }
    

}

extension SearchViewController: UICollectionViewDelegate {
    
}
