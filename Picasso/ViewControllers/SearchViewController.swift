//
//  SearchViewController.swift
//  Picasso
//
//  Created by Pavel Gribachev on 22.02.2024.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: IBOutlets
    // Search
    @IBOutlet weak var searchTF: UITextField! {
        didSet {
            styleTF(searchTF)
            hideButtonFind()
        }
    }
    @IBOutlet weak var searchView: UIView! {
        didSet {
            styleTFView(searchView)
        }
    }
    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.isHidden = true
        }
    }
    
    // Collection View
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    // Preset Buttons
    @IBOutlet weak var carButtonView: FilterView!
    @IBOutlet weak var catButtonView: FilterView!
    @IBOutlet weak var mountainButtonView: FilterView!
    @IBOutlet weak var sportButtonView: FilterView!
    
    //Blur
    @IBOutlet weak var visualEffectBlur: UIVisualEffectView!
    @IBOutlet weak var activityIndicatorBlur: UIActivityIndicatorView! {
        didSet {
            activityIndicatorBlur.hidesWhenStopped = true
        }
    }
    
    // MARK: Properties
    var delegate: SearchViewControllerDelegate!
    private let networkManager = NetworkManager.shared
    private var picasses: [Picasso] = []
    private var searchText = "животные"
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        searchTF.delegate = self
        
        fetchPicassoPreset()
        setUPButtonView()
    }
    
    // MARK: override func
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
        
    // MARK: IBAction
    // Button Find
    @IBAction func searchTFButtonPressed() {
        changeContent()
        searchTF.resignFirstResponder()
    }
}

// MARK: UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    // hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeContent()
        
        return textField.resignFirstResponder()
    }
    // selected text after click
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.perform(#selector(selectAll), with: textField, afterDelay: 0)
        textField.layer.borderColor = UIColor.black.cgColor
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
    
    // select item and transfer per delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImageURL = picasses[indexPath.row].urls.full
        delegate.returnImage(selectedImageURL)
        
        view.addSubview(visualEffectBlur)
        visualEffectBlur.frame = view.frame
        
        activityIndicatorBlur.startAnimating()
        
        
        // transfer after deadline
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            navigationController?.popViewController(animated: true)
            
            // blur views
            activityIndicatorBlur.stopAnimating()
            visualEffectBlur.removeFromSuperview()
        }
    }
}

// MARK: UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    // custom size item cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let imageSize = UIScreen.main.bounds.width / 2 - 18
        
        layout.invalidateLayout()
        
        return CGSize(width: imageSize, height: imageSize)
        }
}

// MARK: Fetch Function
private extension SearchViewController {
    // start view
    func fetchPicassoPreset() {
        networkManager.fetchPicasses(
            withURL: "https://api.unsplash.com/search/photos?query=\(searchText)"
        ) { [unowned self] result in
            switch result {
            case .success(let searchPicasso):
                picasses.append(contentsOf: searchPicasso.results)
                imageCollectionView.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchPicasso() {
        networkManager.fetchPicasses(
            withURL: "https://api.unsplash.com/search/photos?query=\(searchText)"
        ) { [unowned self] result in
            switch result {
            case .success(let searchPicasso):
                picasses.append(contentsOf: searchPicasso.results)
                imageCollectionView.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

// MARK: Function
private extension SearchViewController {
    func setUPButtonView() {
        // car
        carButtonView.label.text = "car"
        carButtonView.imageView.image = UIImage(named: "filterCar")
        
        // cat
        catButtonView.label.text = "cat"
        catButtonView.imageView.image = UIImage(named: "filterCat")
        
        // sport
        sportButtonView.label.text = "sport"
        sportButtonView.imageView.image = UIImage(named: "filterSport")
        
        // mountain
        mountainButtonView.label.text = "mountain"
        mountainButtonView.imageView.image = UIImage(named: "filterMountain")
    }
    
    func changeContent() {
        if searchTF.text != "" {
            searchText = searchTF.text ?? ""
            searchButton.isHidden = true
            picasses.removeAll()
            fetchPicasso()
        }
    }
    
    func styleTF(_ textField: UITextField){
        textField.textColor = .white
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "search...",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)
            ]
        )
    }
    
    func styleTFView(_ view: UIView){
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
    }
    
    func hideButtonFind() {
        let hideButton = UIAction { [unowned self] _ in
            searchButton.isHidden = false
        }
        
        searchTF.addAction(hideButton, for: .editingChanged)
    }
}
