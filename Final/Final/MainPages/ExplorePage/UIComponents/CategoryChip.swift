//
//  CategoryChip.swift
//  Final
//
//  Created by nika kovziridze on 11.01.26.
//

import SwiftUI

struct CategoryChip: View {
    let category: ProductCategory?
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: isSelected
                                    ? [Color(red: 0.45, green: 0.40, blue: 0.85), Color(red: 0.25, green: 0.35, blue: 0.75)]
                                    : [Color(red: 0.18, green: 0.16, blue: 0.28), Color(red: 0.22, green: 0.20, blue: 0.35)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(isSelected ? 1 : 0.8)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isSelected
                            ? Color.white.opacity(0.3)
                            : Color.white.opacity(0.1),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: isSelected
                    ? Color.white.opacity(0.2)
                    : Color.black.opacity(0.15),
                radius: isSelected ? 6 : 2,
                x: 0,
                y: 2
            )
            .scaleEffect(isSelected ? 1.05 : 1)
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
