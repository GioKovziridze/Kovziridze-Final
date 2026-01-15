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

struct CartItem: Codable, Identifiable, Equatable {
    var id: String // productID
    var quantity: Int
}

struct CartDisplayItem: Identifiable {
    let id: String          // productID
    let product: Product
    var quantity: Int
}

