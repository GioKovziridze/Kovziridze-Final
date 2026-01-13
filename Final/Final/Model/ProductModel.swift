//
//  ProductModel.swift
//  Final
//
//  Created by nika kovziridze on 11.01.26.
//

import Foundation


struct Product: Identifiable, Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let rating: Rating
    var image: String {
        "product_\(id)"
    }
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}




