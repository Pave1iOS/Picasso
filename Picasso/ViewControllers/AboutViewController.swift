//
//  AboutViewController.swift
//  Picasso
//
//  Created by Pavel Gribachev on 03.03.2024.
//

import UIKit
import StoreKit

class AboutViewController: UIViewController {
    
    let productIds = ["main"]
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    @IBAction func buyButtonDidTapped(_ sender: UIButton) {
        
        
        Task {
//            guard let product = products.first else { return }
//            try await purchase(product)
            print(products)
        }
    }
    
    private func purchase(_ product: Product) async throws {
       let result = try await product.purchase()
    }
    
    
    func loadProducts() async throws {
        self.products = try await Product.products(for: productIds)
    }
    

}
