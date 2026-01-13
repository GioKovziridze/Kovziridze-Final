//
//  CategoryChip.swift
//  Final
//
//  Created by nika kovziridze on 11.01.26.
//

import SwiftUI

struct CategoryChip: View {
    let category: Category
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
            .foregroundColor(isSelected ? .black : .gray)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? selectedGreen : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? selectedGreen : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(
                color: isSelected ? selectedGreen.opacity(0.35) : .black.opacity(0.05),
                radius: isSelected ? 8 : 3,
                x: 0,
                y: 4
            )
            .animation(.easeInOut(duration: 0.25), value: isSelected)
        }
        .buttonStyle(.plain)
    }
    
    private var selectedGreen: Color {
        Color(red: 0.55, green: 1.0, blue: 0.6)
    }
}
