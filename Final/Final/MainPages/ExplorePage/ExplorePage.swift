//
//  ExplorePage.swift
//  Final
//
//  Created by nika kovziridze on 12.01.26.
//

import SwiftUI

struct ExplorePage: View {
//    @ObservedObject private var userStore = UserStore.shared
    @ObservedObject private var store = ProductStore.shared
    @State private var selectedCategoryID: String?
    
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 16) {
            
            SearchBar(text: $searchText)
                .padding(.horizontal)
            categoryChips
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredProducts) { product in
                        NavigationLink {
                            ProductDetailsPage(product: product)
                        } label: {
                            ProductRowView(product: product)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }

        }
        .navigationTitle("Explore")
    }
    
    
    var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(store.categories) { category in
                    CategoryChip(
                        category: category,
                        title: category.displayName,
                        icon: category.icon,
                        isSelected: selectedCategoryID == category.id
                    ) {
                        selectedCategoryID = category.id
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    //TODO: - Add category filters
    
    var filteredProducts: [Product] {
        guard !searchText.isEmpty else {
            return store.products
        }
        
        return store.products.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
            || $0.category.name.localizedCaseInsensitiveContains(searchText)
        }
    }

}
//TODO: - move this to a separate file

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
            
            TextField("Search products", text: $text)
                .foregroundColor(.black)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color(red: 0.55, green: 1.0, blue: 0.6))
        )
    }
}
//TODO: - this too
struct ProductRowView: View {
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            Image(product.image)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(2)

                Text("$\(product.price, specifier: "%.2f")")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}


#Preview{
    ExplorePage()
}
