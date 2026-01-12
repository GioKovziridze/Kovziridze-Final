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



struct Category: Identifiable, Decodable, Hashable {
    let id: String
    let name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        self.id = value
        self.name = value
    }
}

extension Category {
    var displayName: String {
        name.capitalized
    }

    var icon: String {
        switch name {
        case "men's clothing": return "tshirt.fill"
        case "women's clothing": return "tshirt"
        case "electronics": return "desktopcomputer"
        case "jewelery": return "sparkles"
        default: return "square.grid.2x2"
        }
    }
}

