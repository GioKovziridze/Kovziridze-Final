//
//  ProductCardView.swift
//  Final
//
//  Created by nika kovziridze on 11.01.26.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // IMAGE (REMOTE)
            Image(product.image)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .clipped()

            // TITLE
            Text(product.title)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(2)

            // PRICE
            Text("$\(product.price, specifier: "%.2f")")
                .font(.system(size: 16, weight: .bold))

            // RATING
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
        .frame(width: 200)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
