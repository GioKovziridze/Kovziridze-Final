//
//  ProductCardView.swift
//  Final
//
//  Created by nika kovziridze on 11.01.26.
//

//@State private var isFavorite = false
import SwiftUI

struct ProductCardView: View {
    let product: Product
    @ObservedObject private var userStore = UserStore.shared

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 22)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.18, green: 0.16, blue: 0.28),
                                    Color(red: 0.22, green: 0.20, blue: 0.35)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 8)

            VStack(alignment: .leading, spacing: 8) {

                Image(product.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 8)
                    .offset(y: -6)

                Text(product.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)

                Text("$\(product.price, specifier: "%.2f")")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)

                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(product.rating.rate) ? "star.fill" : "star")
                            .font(.system(size: 11))
                            .foregroundColor(.yellow.opacity(0.9))
                    }

                    Text("(\(product.rating.count))")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(12)

            Button {
                userStore.toggleFavorite(productID: product.id)
            } label: {
                Image(systemName: userStore.isFavorite(productID: product.id) ? "heart.fill" : "heart")
                    .foregroundColor(userStore.isFavorite(productID: product.id) ? .pink : .white)
                    .frame(width: 32, height: 32)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            }
            .padding(6)
        }
        .frame(width: 170, height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}
