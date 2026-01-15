//
//  PaymentSuccessPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI

struct PaymentSuccessPage: View {
    let nextAction: () -> Void
    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(accentGreen)

            Text("Payment Successful")
                .font(.title2.bold())

            Text("Your order has been placed successfully.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button {
                nextAction()
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(accentGreen)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(24)
        .frame(maxWidth: 320)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
        )
        .shadow(radius: 20)
    }
}

