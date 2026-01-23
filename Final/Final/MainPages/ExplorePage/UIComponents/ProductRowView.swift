//
//  ProductRowView.swift
//  Final
//
//  Created by nika kovziridze on 14.01.26.
//

import SwiftUI

import SwiftUI

struct ProductRowView: View {
    let product: Product

    var body: some View {
        HStack(spacing: 14) {
            
            Image(product.image)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.indigo.opacity(0.15), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 6) {
                
                Text(product.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.primary)
                    .lineLimit(2)

                Text("$\(product.price, specifier: "%.2f")")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.indigo)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color.indigo.opacity(0.6))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color.indigo.opacity(0.04)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.indigo.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: Color.indigo.opacity(0.08), radius: 10, x: 0, y: 6)
    }
}
