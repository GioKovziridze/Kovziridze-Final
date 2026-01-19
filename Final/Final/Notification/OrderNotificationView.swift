//
//  OrderNotificationView.swift
//  Final
//
//  Created by nika kovziridze on 19.01.26.
//

import SwiftUI

import SwiftUI

struct OrderNotificationView: View {
    let message: String
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "bag.fill")
                .foregroundColor(.black)
                .font(.title2)

            Text(message)
                .foregroundColor(.black)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()

            Button(action: action) {
                Text("Track")
                    .bold()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.black)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            LinearGradient(colors: [Color.green, Color.green.opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 3)
        .padding(.horizontal, 16)
        .padding(.top, 50)
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(1)
    }
}
