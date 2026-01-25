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
    @Published var categories: [ProductCategory] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var cartProducts: [Product] = []
    
    private var hasLoadedInitialData = false
    static let shared = ProductStore()
    
    private init() {}
    
    func loadInitialDataIfNeeded() async {
        guard !hasLoadedInitialData else { return }
        hasLoadedInitialData = true
        
        isLoading = true
        errorMessage = nil
        
        async let productsTask: () = loadProducts()
        async let categoriesTask: () = loadCategories()
        
        _ = await (productsTask, categoriesTask)
        
        isLoading = false
        print("Network call has been made")
    }
    
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
    
    func loadCategories() async {
        do {
            categories = try await NetworkManager.shared.fetchCategories()
            print(categories.count)
        } catch {
            errorMessage = error.localizedDescription
            print("failed to load categories")
        }
    }
    
    
   
}
