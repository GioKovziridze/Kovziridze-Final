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
    let slug: String
    let price: Int
    let description: String
    let category: Category
    let images: [String]
}

struct Category: Identifiable, Decodable {
    let id: Int
    let name: String
    let slug: String
    let image: String
}

