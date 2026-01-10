//
//  ProductStore.swift
//  Final
//
//  Created by nika kovziridze on 11.01.26.
//

import SwiftUI

@MainActor
final class ProductStore: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    static let shared = ProductStore()
    
    private init() {}
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await NetworkManager.shared.fetchProducts()
        } catch {
            errorMessage = error.localizedDescription
            print("failed to load products")
        }
        
        isLoading = false
    }
}
