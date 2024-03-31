//
//  BuyViewController.swift
//  Picasso
//
//  Created by Pavel Gribachev on 10.03.2024.
//

import UIKit
import StoreKit

class BuyViewController: UIViewController {
    
    @IBOutlet weak var backgraudText: UILabel!{
        didSet {
            backgraudText.text = "Hello my friend click on “Buy” to support me 😉"
            backgraudText.textColor = .white
        }
    }
    @IBOutlet weak var backgraundViewBuy: UIView! {
        didSet {
            backgraundViewBuy.backgroundColor = .gray
            backgraundViewBuy.alpha = 1
            backgraundViewBuy.layer.cornerRadius = 20
            backgraundViewBuy.layer.borderColor = UIColor.white.cgColor
            backgraundViewBuy.layer.borderWidth = 1
        }
    }
    
    let productIds = ["main"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buyDidTapped() {
        Task {
            let products = try await Product.products(for: productIds)
            
            products.forEach{ product in
                Task {
                    do {
                        try await self.purchase(product)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    private func purchase(_ product: Product) async throws {
       let result = try await product.purchase()
        
        switch result {
            case let .success(.verified(transaction)):
                // Successful purchase
                await transaction.finish()
            case let .success(.unverified(_, error)):
                print(error)
                break
            case .pending:
                // Transaction waiting on SCA (Strong Customer Authentication) or
                // approval from Ask to Buy
                break
            case .userCancelled:
                print("Cancel")
                break
            @unknown default:
                break
            }
    }
}
