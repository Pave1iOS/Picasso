//
//  BuyViewController.swift
//  Picasso
//
//  Created by Pavel Gribachev on 10.03.2024.
//

import UIKit
import StoreKit

class BuyViewController: UIViewController {
    
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
                    // Successful purchase but transaction/receipt can't be verified
                    // Could be a jailbroken phone
                    break
                case .pending:
                    // Transaction waiting on SCA (Strong Customer Authentication) or
                    // approval from Ask to Buy
                    break
                case .userCancelled:
                    // ^^^
                    break
                @unknown default:
                    break
                }
    }
}
