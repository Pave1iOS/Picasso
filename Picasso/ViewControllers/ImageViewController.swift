//
//  ViewController.swift
//  Picasso
//
//  Created by Pavel Gribachev on 20.02.2024.
//

import UIKit
import SpringAnimation

final class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: SpringImageView!
    @IBOutlet weak var nextImageButton: SpringView!
    
    @IBOutlet weak var activityIndicatorImage: UIActivityIndicatorView! {
        didSet {
            activityIndicatorImage.startAnimating()
            activityIndicatorImage.hidesWhenStopped = true
        }
    }
    
    let networkManager = NetworkManager.shared
    
    let imageArray = ["testImage", "testImage2"] // TEST
    var indexNumber = 0 { // TEST
        didSet {
            if indexNumber >= imageArray.count {
                indexNumber = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: imageArray[indexNumber]) // TEST
    }

    @IBAction func changeImageDidTapped() {
        activityIndicatorImage.startAnimating()
//        fetchPicasso()
        
        
        indexNumber += 1 // TEST
        imageView.image = UIImage(named: imageArray[indexNumber]) // TEST
        activityIndicatorImage.stopAnimating() // TEST
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
        networkManager.fetchPicasso(from: "https://api.unsplash.com/photos/random/") { [unowned self] result in
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
