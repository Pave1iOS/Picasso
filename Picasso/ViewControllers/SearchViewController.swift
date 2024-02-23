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
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "imageItem", for: indexPath) as? ImageItemCollectionView
        
        
        DispatchQueue.main.async {
            item?.imageItemCV.image = UIImage(named: "testImage2")
        }
        
        
        return item ?? UICollectionViewCell()
    }
    
    

}

extension SearchViewController: UICollectionViewDelegate {
    
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let imageSize = UIScreen.main.bounds.width / 2 - 18
        
        layout.invalidateLayout()
        
        return CGSize(width: imageSize, height: imageSize)

            

//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.sectionInset = UIEdgeInsets(top: 6, left: 4, bottom: 6, right: 4)
//        layout.minimumInteritemSpacing = 04
//        layout.minimumLineSpacing = 04
//        return CGSize(width: ((self.view.frame.width/2) - 6), height: ((self.view.frame.width / 2) - 6))
        }
}
