//
//  ProductRowView.swift
//  Final
//
//  Created by nika kovziridze on 14.01.26.
//

import SwiftUI

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
