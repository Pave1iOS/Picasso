//
//  Picasso.swift
//  Picasso
//
//  Created by Pavel Gribachev on 20.02.2024.
//

import Foundation

struct SearchPicasso: Decodable {

    let results: [Picasso]
}

struct Picasso: Decodable {
    let id: String
    let width: Int
    let height: Int
    let color: String
    let blur_hash: String
//    let location: Location
    let urls: Urls
    let links: Links
}

//struct Location: Decodable {
//    let city: String
//    let country: String
//}

struct Urls: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Links: Decodable {
    let html: String
    let download: String
}




