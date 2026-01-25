//
//  HomeCategoryCard.swift
//  Final
//
//  Created by nika kovziridze on 12.01.26.
//

import SwiftUI

struct HomeCategoryCard: View {
    let category: ProductCategory
    let productCount: Int

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.14, green: 0.13, blue: 0.25),
                            Color(red: 0.20, green: 0.18, blue: 0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.45, green: 0.40, blue: 0.85))
                            .frame(width: 120)
                            .blur(radius: 24)
                            .offset(x: 80, y: -90)

                        Circle()
                            .fill(Color(red: 0.25, green: 0.35, blue: 0.75))
                            .frame(width: 100)
                            .blur(radius: 30)
                            .offset(x: -80, y: 90)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .frame(width: 160)
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
                .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 10)

            VStack(alignment: .leading, spacing: 6) {
                Spacer()

                Text(category.displayName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)

                Text("\(productCount) collections")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.65))
            }
            .padding(16)
        }
        .frame(width: 170, height: 170)
        .overlay(
            Image(category.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 110)
                .offset(y: -8)
                .shadow(color: .black.opacity(0.45), radius: 18, x: 0, y: 14),
            alignment: .top
        )
    }
}
