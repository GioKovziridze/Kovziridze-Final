//
//  CategoryProductsPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//


import SwiftUI

struct CategoryProductsPage: View {
    let category: Category

    @ObservedObject private var store = ProductStore.shared

    var products: [Product] {
        store.products.filter {
            $0.category == category
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(products) { product in
                    ProductRowView(product: product)
                }
            }
            .padding()
        }
        .navigationTitle(category.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

