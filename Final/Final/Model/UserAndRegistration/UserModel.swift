//
//  UserModel.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//
import Foundation
import FirebaseFirestore

struct UserModel: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var city: String
    var cart: [CartItem] = []
    var favorites: [String] = []
    var orders: [Order] = []
    
    var displayCity: String {
        city.isEmpty ? "New York" : city
    }
}

struct CartItem: Codable, Identifiable, Equatable {
    var id: String // productID
    var quantity: Int
}

struct CartDisplayItem: Codable, Identifiable {
    let id: String          // productID
    let product: Product
    var quantity: Int
}

extension CartDisplayItem {
    init(product: Product, quantity: Int = 1) {
        self.id = String(product.id)
        self.product = product
        self.quantity = quantity
    }
}

