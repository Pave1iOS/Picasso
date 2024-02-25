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
            searchTF.layer.cornerRadius = presetFiltersViews.cornerRadius
        }
    }
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    private let presetFiltersViews = PresetFiltersView()
    private let networkManager = NetworkManager.shared
    private var searchPicasso: [Picasso] = []
    private let searchText = "flowers"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        fetchPicassoImages()
        
    }
    
}

// MARK: UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "imageItem", for: indexPath) as? ImageItemCollectionView
//        let imagesPicasso = searchPicasso[indexPath.row].results
//        let picasso = imagesPicasso[indexPath.row]
        
//        item?.configure(with: picasso)
        
        
//        item?.imageItemCV.image = UIImage(named: image.results.forEach { $0.urls.regular })
        
        return item ?? UICollectionViewCell()
    }
    
    

}

// MARK: UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    
    
}

// MARK: UICollectionViewDelegateFlowLayout
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

private extension SearchViewController {
    func fetchPicassoImages() {
        networkManager.fetchPicassoImageSet(withURL: "https://api.unsplash.com/search/photos?query=\(searchText)") { result in
            switch result {
            case .success(let searchPicasso):
                self.searchPicasso.append(contentsOf: searchPicasso.results)
                //self.searchPicasso = searchPicasso
                print(searchPicasso)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
