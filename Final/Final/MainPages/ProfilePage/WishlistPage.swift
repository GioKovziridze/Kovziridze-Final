//
//  WishlistPage.swift
//  Final
//
//  Created by nika kovziridze on 17.01.26.
//

import SwiftUI

struct WishlistPage: View {
    @ObservedObject private var userStore = UserStore.shared
    @ObservedObject private var productStore = ProductStore.shared
    
    private let cardWidth: CGFloat = 160
    private let cardHeight: CGFloat = 250
    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)
    
    var body: some View {
        ScrollView {
            
            Text("Your Wishlist")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 24) {
                
                if userStore.currentUser?.favorites.isEmpty ?? true {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray.opacity(0.6))
                        
                        Text("Your wishlist is empty")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Text("Tap the heart icon on a product to add it here.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .padding(.top, 60)
                } else {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ],
                        spacing: 20
                    ) {
                        ForEach(productStore.products.filter { product in
                            userStore.isFavorite(productID: product.id)
                        }) { product in
                            WishlistCard(product: product)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 60)
            }
        }
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}

// MARK: - Wishlist Card
struct WishlistCard: View {
    let product: Product
    @ObservedObject private var userStore = UserStore.shared
    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Image(product.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .scaledToFill()
                
                Button {
                    userStore.toggleFavorite(productID: product.id)
                } label: {
                    Image(systemName: userStore.isFavorite(productID: product.id) ? "heart.fill" : "heart")
                        .foregroundColor(userStore.isFavorite(productID: product.id) ? .red : .gray)
                        .padding(8)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(8)
            }
            
            Text(product.title)
                .font(.system(size: 14, weight: .semibold))
                .lineLimit(2)
                .foregroundColor(.black)
            
            Text("$\(product.price, specifier: "%.2f")")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(accentGreen)
            
            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(product.rating.rate) ? "star.fill" : "star")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                }
                Text("(\(product.rating.count))")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}


