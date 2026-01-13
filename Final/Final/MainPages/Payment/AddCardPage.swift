//
//  AddCardPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI

struct AddCardPage: View {

    @ObservedObject private var paymentStore = PaymentStore.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {

            Text("Add Card")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("This is a mocked card. No real payment.")
                .foregroundColor(.gray)

            Button {
                paymentStore.addMockCard()
                dismiss()
            } label: {
                Text("Add test card (Visa •••• 4242)")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Spacer()
        }
        .padding()
    }
}
