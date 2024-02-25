//
//  SearchViewController.swift
//  Picasso
//
//  Created by Pavel Gribachev on 22.02.2024.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: IBOutlets
    
    // Search
    @IBOutlet weak var searchTF: UITextField! {
        didSet {
            searchTF.layer.cornerRadius = cornerRadius
        }
    }
    
    //Collection View
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    // Preset Buttons
    @IBOutlet var presetsFilterView: [UIView]!
    @IBOutlet var presetsFilterImage: [UIImageView]!
    @IBOutlet var presetsFilterLabel: [UILabel]!
    
    // MARK: Properties
    private let networkManager = NetworkManager.shared
    private var picasses: [Picasso] = []
    private let searchText = "sport"
    private let cornerRadius: CGFloat = 10
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        fetchPicassoImages()
        setUPPresetButtons()
    }
}

// MARK: UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        picasses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "imageItem", for: indexPath) as? ImageItemCollectionView
        let picassoImage = picasses[indexPath.row]
        
        item?.configure(with: picassoImage)
                
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
        networkManager.fetchPicassoImageSet(
            withURL: "https://api.unsplash.com/search/photos?query=\(searchText)"
        ) { [unowned self] result in
            switch result {
            case .success(let searchPicasso):
                picasses.append(contentsOf: searchPicasso.results)
                imageCollectionView.reloadData()
                //self.searchPicasso = searchPicasso
                print(searchPicasso)
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
}

// MARK: Function
private extension SearchViewController {
    func setUPPresetButtons() {
        //views
        presetsFilterView.forEach { $0.backgroundColor = .clear }

        // imageViews
        presetsFilterImage.forEach { $0.layer.cornerRadius = cornerRadius / 2 }
        presetsFilterImage.forEach{ $0.contentMode = .scaleAspectFill }
        presetsFilterImage.forEach{ $0.alpha = 0.5 }
        
        setTitleButtons()
    }
    
    func setTitleButtons() {
        let imagesName = ["filterCar","filterCat","filterMountain","filterSport"]
        let titles = ["car", "cat", "mountain", "sport"]
        let iterationCount = min(presetsFilterView.count, presetsFilterImage.count)
        
//        DispatchQueue.main.async { [unowned self] in
            for index in 0..<iterationCount {
                presetsFilterImage[index].image = UIImage(named: imagesName[index])
                presetsFilterLabel[index].text = titles[index]
            }
            
//        }
        
    }
}
