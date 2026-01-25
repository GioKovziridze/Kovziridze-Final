//
//  OrderNotificationView.swift
//  Final
//
//  Created by nika kovziridze on 19.01.26.
//

import SwiftUI

struct OrderNotificationView: View {
    let message: String
    let action: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: "bag.fill")
                    .foregroundColor(Color.green)
                    .font(.system(size: 20, weight: .bold))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Order Confirmed")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(message)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            Button(action: action) {
                Text("Track")
                    .font(.footnote)
                    .bold()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.indigo.opacity(0.1))
                    .foregroundColor(.indigo)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
        .padding(.top, 50)
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(1)
    }
}
