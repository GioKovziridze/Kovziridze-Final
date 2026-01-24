//
//  PaymentSuccessPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI

struct PaymentSuccessPage: View {
    let nextAction: () -> Void
    @State private var show = false
    
    private let primaryIndigo = Color.indigo
    private let deepPurple = Color(red: 0.22, green: 0.18, blue: 0.35)

    var body: some View {
        VStack(spacing: 22) {

            // MARK: - Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [primaryIndigo, deepPurple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 88, height: 88)
                    .shadow(color: primaryIndigo.opacity(0.35), radius: 18)

                Image(systemName: "checkmark")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }

            // MARK: - Text
            VStack(spacing: 6) {
                Text("Payment Complete")
                    .font(.title3.bold())

                Text("Your order is confirmed and being prepared.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // MARK: - CTA
            Button(action: nextAction) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [primaryIndigo, deepPurple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.top, 8)
        }
        .padding(28)
        .frame(maxWidth: 340)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
        )
        .shadow(color: deepPurple.opacity(0.25), radius: 30, y: 12)
        .scaleEffect(show ? 1 : 0.9)
        .opacity(show ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                show = true
            }
        }
    }
}
