//
//  CategoryModel.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import Foundation

struct ProductCategory: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        self.id = value
        self.name = value
    }
}

extension ProductCategory {
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
    func productCount(in products: [Product]) -> Int {
        products.filter { $0.category == self }.count
    }
}

