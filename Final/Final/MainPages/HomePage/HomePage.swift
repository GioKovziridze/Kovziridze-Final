//
//  HomePage.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation
import SwiftUI
import UserNotifications

struct HomePage: View {
    @ObservedObject private var userStore = UserStore.shared
    @ObservedObject private var store = ProductStore.shared

    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.98, blue: 0.96)
                .ignoresSafeArea()
            
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        header
                        promoBanner
                        
                        Text("Category")
                            .font(.custom("Poppins-Medium", size: 26))
                            .foregroundColor(.black)
                            .padding(.trailing, 230)
                            .padding(4)
                        
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
                        await store.loadInitialDataIfNeeded()
                    }
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .navigationBar)
            
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
            
            GlassIconButton(systemImage: "person.fill") {
                TabBarController.shared?.switchToProfileTab()
            }
            
            GlassIconButton(systemImage: "heart") {
                // favorite action
            }
        }
        .padding()
    }
    var promoBanner: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.10, blue: 0.25),
                            Color(red: 0.18, green: 0.15, blue: 0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.45, green: 0.40, blue: 0.85))
                            .frame(width: 180)
                            .blur(radius: 24)
                            .offset(x: 140, y: -110)

                        Circle()
                            .fill(Color(red: 0.25, green: 0.35, blue: 0.75))
                            .frame(width: 160)
                            .blur(radius: 34)
                            .offset(x: -140, y: 120)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.14),
                                    Color.white.opacity(0.02)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .shadow(color: .black.opacity(0.38), radius: 20, x: 0, y: 14)

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Discover the latest")
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundColor(.white.opacity(0.7))

                    Text("Collections")
                        .font(.custom("Poppins-SemiBold", size: 27))
                        .foregroundColor(.white)
                }

                Spacer()

                Image("model6")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 180)
                    .shadow(color: .black.opacity(0.5), radius: 24, x: 0, y: 16)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        .frame(width: 360, height: 200)
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
    
