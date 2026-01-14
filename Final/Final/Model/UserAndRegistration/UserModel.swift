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
}

struct CartItem: Codable, Identifiable {
    var id: String // productID
    var quantity: Int
}

struct ProductModel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var price: Double
    var imageURL: String
    var category: String
}

