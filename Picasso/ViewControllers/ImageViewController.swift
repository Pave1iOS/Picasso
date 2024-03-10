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
    @IBOutlet weak var imageView: SpringImageView! {
        didSet {
            addParallaxToView(imageView)
        }
    }
    @IBOutlet weak var nextImageButton: SpringView!
    
    @IBOutlet weak var activityIndicatorImage: UIActivityIndicatorView! {
        didSet {
            activityIndicatorImage.startAnimating()
            activityIndicatorImage.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var veBlur: UIVisualEffectView!
    @IBOutlet weak var veActivity: UIActivityIndicatorView! {
        didSet {
            veActivity.hidesWhenStopped = true
        }
    }
    
    
    // MARK: Properties
    let networkManager = NetworkManager.shared
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPicasso()
    }

    // MARK: @IBAction
    @IBAction func changeImageDidTapped() {
        activityIndicatorImage.startAnimating()
        loadingLabel.isHidden = false
        fetchPicasso()
    }
        
    // MARK: override func
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchVC = segue.destination as? SearchViewController
        
        searchVC?.delegate = self
    }
}

// MARK: Protocol - SearchViewControllerDelegate
extension ImageViewController: SearchViewControllerDelegate {
    func returnImage(_ imageURL: String) {
        
        // add visual effect view
        view.addSubview(veBlur)
        veBlur.frame = view.frame
        veActivity.startAnimating()
        
        // hide minimalistic indicator
        activityIndicatorImage.stopAnimating()
        loadingLabel.isHidden = true
        
        // display image, after fetch
        networkManager.fetchImage(from: URL(string: imageURL)!) { [unowned self] dataImage in
            imageView.image = UIImage(data: dataImage)
            
            veActivity.stopAnimating()
            veBlur.removeFromSuperview()
            imageAppeared()
        }
    }
}

private extension ImageViewController {
    func addParallaxToView(_ view: UIView) {
        let amount = 50

        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
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
    
    func imageAppeared() {
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
                
                activityIndicatorImage.stopAnimating()
                loadingLabel.isHidden = true
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRandomImage(_ data: Picasso) {
        networkManager.fetchImage(from: URL(string: data.urls.regular)!) { [unowned self] dataImage in
            imageView.image = UIImage(data: dataImage)
            nextImageAnimate()
        }
    }
}
