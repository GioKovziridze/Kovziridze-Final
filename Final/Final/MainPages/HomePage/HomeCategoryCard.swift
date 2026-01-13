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
        VStack(alignment: .leading, spacing: 12) {

            Image(systemName: category.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .padding(10)
                .background(Color.white.opacity(0.25))
                .clipShape(Circle())

            Spacer()

            Text(category.displayName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)

            Text("\(productCount) Collections")
                .font(.system(size: 13))
                .foregroundColor(.black.opacity(0.8))
        }
        .padding(16)
        .frame(width: 170, height: 170)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.55, green: 0.95, blue: 0.70),
                    Color(red: 0.45, green: 0.85, blue: 0.65)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.green.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}


