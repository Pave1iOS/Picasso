//
//  NetworkManager.swift
//  Picasso
//
//  Created by Pavel Gribachev on 20.02.2024.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchPicasses(withURL url: String, handler: @escaping (Result<SearchPicasso, AFError>) -> Void) {
        AF.request(url,
            parameters: ["per_page": 30],
            headers: ["Authorization": "Client-ID XXD-C_ut3-D7jl2VKQ-vzWvDMihqK8023vDhp2UDzU8"])
            .validate()
            .responseDecodable(of: SearchPicasso.self, completionHandler: { response in
                switch response.result {
                case .success(let data):
                    handler(.success(data))
                case .failure(let error):
                    handler(.failure(error))
                }
            })
    }
    
    func fetchPicasso(handler: @escaping (Result<Picasso, AFError>) -> Void) {
        AF.request(
            "https://api.unsplash.com/photos/random/",
            headers: ["Authorization": "Client-ID XXD-C_ut3-D7jl2VKQ-vzWvDMihqK8023vDhp2UDzU8"]
        )
            .validate()
            .responseDecodable(of: Picasso.self) { response in
                switch response.result {
                case .success(let data):
                    handler(.success(data))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
    }
        
    func fetchImage(from url: URL, handler: @escaping(Data) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                handler(imageData)
            }
        }
    }
}
