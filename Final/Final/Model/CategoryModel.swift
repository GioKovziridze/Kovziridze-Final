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
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            self.id = try container.decode(String.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            return
        }
        
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
    var imageName: String {
        switch name {
        case "men's clothing": return "model5"
        case "women's clothing": return "model7"
        case "electronics": return "model8"
        case "jewelery": return "model9"
        default: return "square.grid.2x2"
        }
    }
    func productCount(in products: [Product]) -> Int {
        products.filter { $0.category == self }.count
    }
}

