//
//  ProductCardView.swift
//  Final
//
//  Created by nika kovziridze on 11.01.26.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    @ObservedObject private var userStore = UserStore.shared
    @State private var isFavorite = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            ZStack(alignment: .topTrailing) {
                Image(product.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .clipped()

                Button {
                    userStore.toggleFavorite(productID: product.id)
                } label: {
                    Image(systemName: userStore.isFavorite(productID: product.id) ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .padding(8)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(.leading, 15)
            }

            Text(product.title)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(2)

            Text("$\(product.price, specifier: "%.2f")")
                .font(.system(size: 16, weight: .bold))

            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(product.rating.rate) ? "star.fill" : "star")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                }

                Text("(\(product.rating.count))")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .frame(width: 170, height: 230)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
