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
    let imageArray = ["testImage", "testImage2", "testImage3", "testImage4", "testImage5", "testImage6"] // TEST

    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
    }
    
    

}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "imageItem", for: indexPath) as? ImageItemCollectionView
        
        let currentImage = imageArray[indexPath.row]
        
        item?.imageItemCV.image = UIImage(named: currentImage)
        
        
        
        return item ?? UICollectionViewCell()
    }
    
    

}

extension SearchViewController: UICollectionViewDelegate {
    
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0.5
        layout.minimumLineSpacing = 0.5
        let mySize = UIScreen.main.bounds.width / 2 - 17
        layout.invalidateLayout()

        return CGSize(width: mySize, height: mySize)

            

//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.sectionInset = UIEdgeInsets(top: 6, left: 4, bottom: 6, right: 4)
//        layout.minimumInteritemSpacing = 04
//        layout.minimumLineSpacing = 04
//        return CGSize(width: ((self.view.frame.width/2) - 6), height: ((self.view.frame.width / 2) - 6))
        }
}

