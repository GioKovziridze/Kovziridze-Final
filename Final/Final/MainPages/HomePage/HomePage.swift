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
   
    //TODO: - remove this test category
    
    @State private var selectedCategory: Category?

    var body: some View {
        VStack(spacing: 20) {
            header
                .padding()
            promoBanner
            
            HStack{
                Text("Category")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Text("See all")
                    .foregroundColor(.black)
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(store.categories) { category in
                        CategoryChip(
                            category: category,
                            title: category.displayName,
                            icon: category.icon,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(store.products) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            
            

            
        }
        .task {
            await store.loadProducts()
            print(store.products)
            print("---------------")
            print(store.categories)
        }
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
                // favorite action
            } label: {
                Image(systemName: "heart")
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color(.lightGray).opacity(0.3))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
    
     var promoBanner: some View {
        HStack(spacing: 16) {

            // TEXT SIDE
            VStack(alignment: .leading, spacing: 8) {
                Text("Don’t miss out!")
                    .font(.subheadline)
                    .foregroundColor(.black)

                Text("Discover the latest collections\npicked just for you.")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.7))
            }

            Spacer()

            Image("model4")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 180)
                .offset(x: 0, y: 35)
        }
        .padding(16)
        .frame(width: 340, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(CGColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1)))
        )
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)
        .padding(.horizontal)
    }


}


#Preview {
    HomePage()
}
    
