//
//  ViewController.swift
//  Picasso
//
//  Created by Pavel Gribachev on 20.02.2024.
//

import UIKit
import SpringAnimation

// MARK: Protocol SearchViewControllerDelegate
protocol SearchViewControllerDelegate {
    func returnImage(_ imageURL: String)
}

final class ImageViewController: UIViewController {

    // MARK: @IBOutlets
    @IBOutlet weak var imageView: SpringImageView!
    @IBOutlet weak var nextImageButton: SpringView!
    
    @IBOutlet weak var activityIndicatorImage: UIActivityIndicatorView! {
        didSet {
            activityIndicatorImage.startAnimating()
            activityIndicatorImage.hidesWhenStopped = true
        }
    }
    
    // MARK: Properties
    let networkManager = NetworkManager.shared
    
    let imageArray = ["testImage", "testImage2", "testImage3", "testImage4", "testImage5", "testImage6"] // TEST
    var indexNumber = 0 { // TEST
        didSet {
            if indexNumber >= imageArray.count {
                indexNumber = 0
            }
        }
    }
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: imageArray[indexNumber]) // TEST
    }

    // MARK: @IBAction
    @IBAction func changeImageDidTapped() {
        activityIndicatorImage.startAnimating()
//        fetchPicasso()
        
        nextImageAnimate() // TEST
        indexNumber += 1 // TEST
        imageView.image = UIImage(named: imageArray[indexNumber]) // TEST
        activityIndicatorImage.stopAnimating() // TEST
    }
        
    // MARK: override func
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchVC = segue.destination as? SearchViewController
        
        searchVC?.delegate = self
    }
}

// MARK: SearchViewControllerDelegate
extension ImageViewController: SearchViewControllerDelegate {
    func returnImage(_ imageURL: String) {
        networkManager.fetchImage(from: URL(string: imageURL)!) { [unowned self] dataImage in
            imageView.image = UIImage(data: dataImage)
        }
    }
}

// MARK: Animation
private extension ImageViewController {
    func nextImageAnimate(){
        nextImageButton.animation = "swing"
        nextImageButton.force = 7
        nextImageButton.animate()
        
        imageView.animation = "fadeIn"
        imageView.duration = 2
        imageView.animate()
    }
}

// MARK: Fetch
private extension ImageViewController {
    func fetchPicasso() {
        networkManager.fetchPicasso { [unowned self] result in
            switch result {
            case .success(let data):
                
                fetchRandomImage(data)
                nextImageAnimate()
                
                activityIndicatorImage.stopAnimating()
                
                print(data) // TEST
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRandomImage(_ data: Picasso) {
        networkManager.fetchImage(from: URL(string: data.urls.regular)!) { [unowned self] dataImage in
            imageView.image = UIImage(data: dataImage)
        }
    }
}
