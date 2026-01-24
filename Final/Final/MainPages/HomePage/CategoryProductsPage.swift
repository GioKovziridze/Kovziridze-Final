//
//  CategoryProductsPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//


import SwiftUI

struct CategoryProductsPage: View {
    let category: ProductCategory
    @Environment(\.dismiss) private var dismiss
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
                    NavigationLink {
                        ProductDetailsPage(product: product)
                    } label: {
                        ProductRowView(product: product)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle(category.displayName)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.indigo)
                }
            }
        }
    }
}

