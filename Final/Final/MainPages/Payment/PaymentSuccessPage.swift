//
//  PaymentSuccessPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI

struct PaymentSuccessPage: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("Payment Successful")
                .font(.title)
                .fontWeight(.bold)

            Text("Your order has been placed.")
                .foregroundColor(.gray)
        }
        .padding()
    }
}
