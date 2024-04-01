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
    
    @IBOutlet weak var statusBarBackgraund: UIView!
    

    // MARK: @IBOutlets
    @IBOutlet weak var imageView: SpringImageView! {
        didSet {
            addParallaxToView(imageView)
        }
    }
    @IBOutlet weak var nextImageButton: SpringView!
    @IBOutlet weak var saveImageButton: SpringView!
    @IBOutlet weak var shareImageButton: UIView!
    
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
    var imageURL: String!
    
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
    
    @IBAction func downloadImageDidTapped() {
                
        guard let selectedImage = imageView.image else {
            print("image not found")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_: didFinishSavingWithError:contextInfo:)), nil)
        savedImageAnimation()
    }
    
    @IBAction func sharedButtonDidTapped() {
        if imageURL != nil {
            guard let url = NSURL(string: imageURL) else { return }
            UIApplication.shared.open(url as URL)
        } else {
            imageURL = "https://github.com/Pave1iOS/Picasso"
        }
    }
    
    // MARK: override func
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchVC = segue.destination as? SearchViewController
        
        searchVC?.delegate = self
    }
    
    // поворот экрана
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            interface(isHidden: true)
        } else if UIDevice.current.orientation.isPortrait {
            print("isPortrait")
            interface(isHidden: false)
        }
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
    
    // save image
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(with: "Save error", andMassage: error.localizedDescription)
        } else {
            showAlert(with: "Saved!", andMassage: "Photo saved to camera roll.")
        }
    }
    
    func showAlert(with title: String, andMassage massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func interface(isHidden bool: Bool) {
        navigationController?.isNavigationBarHidden = bool
        statusBarBackgraund.isHidden = bool
        nextImageButton.isHidden = bool
        saveImageButton.isHidden = bool
        shareImageButton.isHidden = bool
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
    
    func savedImageAnimation() {
        saveImageButton.animation = "morph"
        saveImageButton.curve = "linear"
        saveImageButton.animate()
    }
}

// MARK: Fetch
private extension ImageViewController {
    func fetchPicasso() {
        networkManager.fetchPicasso { [unowned self] result in
            switch result {
            case .success(let data):
                fetchRandomImage(data)
                
                imageURL = data.urls.full
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
