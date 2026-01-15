//
//  HomePage.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation
import SwiftUI

struct HomePage: View {
    @ObservedObject private var userStore = UserStore.shared
    @ObservedObject private var store = ProductStore.shared

    //TODO: - remove this later
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                promoBanner
                
                Text("Category")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.trailing, 200)
             
                categoryGrid
                
                Text("Featured products")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.trailing, 200)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(store.products.prefix(5)) { product in
                            NavigationLink {
                                ProductDetailsPage(product: product)
                            } label: {
                                ProductCardView(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }

                
                
                
                
            }
            .task {
                await store.loadProducts()
                await store.loadCategories()
                print("---------------")
                print(store.categories.count)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    
    @ViewBuilder
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if let user = userStore.currentUser {
                    Text("Hello, \(user.username)!")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Text(user.city)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.black.opacity(0.75))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.12))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.gray.opacity(0.25), lineWidth: 0.5)
                    )
                    
                } else {
                    Text("Welcome, guest!")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            
            Spacer()
            
            Button {
                TabBarController.shared?.switchToProfileTab()
            } label: {
                Image(systemName: "person.fill")
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color(red: 0.55, green: 1.0, blue: 0.6).opacity(0.5))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(.plain)
            
            Button {
                // favorite action
            } label: {
                Image(systemName: "heart")
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color(red: 0.55, green: 1.0, blue: 0.6).opacity(0.5))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
    
    var promoBanner: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.55, green: 1.0, blue: 0.6))

                Circle()
                    .fill(Color(red: 0.1, green: 0.6, blue: 0.35))
                    .frame(width: 140, height: 140)
                    .offset(x: 125, y: -100)
                
                Circle()
                    .fill(Color(red: 0.85, green: 1.0, blue: 0.9))
                    .frame(width: 160, height: 160)
                    .offset(x: -155, y: 100)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Discover the latest collections")
                        .font(.system(size: 29, weight: .bold))
                        .foregroundColor(.black.opacity(0.7))
                }

                Spacer()

                Image("model4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 190)
                    .offset(y: 35)
            }
            .padding()
        }
        .frame(width: 360, height: 150)
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)
        .padding()
    }
    
    var categoryGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(store.categories) { category in
                NavigationLink {
                    CategoryProductsPage(category: category)
                } label: {
                    HomeCategoryCard(
                        category: category,
                        productCount: category.productCount(in: store.products)
                    )
                }
            }
        }
        .padding(.horizontal)
    }

}


#Preview {
    HomePage()
}
    
