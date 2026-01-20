//
//  ExplorePage.swift
//  Final
//
//  Created by nika kovziridze on 12.01.26.
//

import SwiftUI

struct ExplorePage: View {
    @ObservedObject private var userStore = UserStore.shared
    @ObservedObject private var store = ProductStore.shared
    @State private var selectedCategoryID: String?

    @State private var searchText = ""
    
    let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                categoryChips
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredProducts) { product in
                            NavigationLink {
                                ProductDetailsPage(product: product)
                            } label: {
                                ProductCardView(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
        }
    }
    
    var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    category: nil,
                    title: "All",
                    icon: "square.grid.2x2",
                    isSelected: selectedCategoryID == nil
                ) {
                    selectedCategoryID = nil
                }
                ForEach(store.categories) { category in
                    CategoryChip(
                        category: category,
                        title: category.displayName,
                        icon: category.icon,
                        isSelected: selectedCategoryID == category.id
                    ) {
                        if selectedCategoryID == category.id {
                            selectedCategoryID = nil
                        } else {
                            selectedCategoryID = category.id
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var filteredProducts: [Product] {
        store.products.filter { product in

            let matchesCategory: Bool = {
                guard let selectedCategoryID else { return true }
                return product.category.id == selectedCategoryID
            }()

            let matchesSearch: Bool = {
                guard !searchText.isEmpty else { return true }
                return product.title.localizedCaseInsensitiveContains(searchText)
                || product.category.name.localizedCaseInsensitiveContains(searchText)
            }()

            return matchesCategory && matchesSearch
        }
    }


}

#Preview{
    ExplorePage()
}
