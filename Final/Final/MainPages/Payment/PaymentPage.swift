//
//  PaymentPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI

struct PaymentPage: View {

    let product: Product
    @ObservedObject private var paymentStore = PaymentStore.shared

    @State private var showAddCard = false
    @State private var showSuccess = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Order Summary")
                        .font(.headline)

                    Text(product.title)
                        .font(.subheadline)

                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if let card = paymentStore.savedCard {
                    cardView(card)
                } else {
                    addCardPrompt
                }

                Spacer()

                Button {
                    pay()
                } label: {
                    if paymentStore.isProcessing {
                        ProgressView()
                    } else {
                        Text("Pay now")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(paymentStore.savedCard == nil ? Color.gray : Color.green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .disabled(paymentStore.savedCard == nil || paymentStore.isProcessing)
            }
            .padding()
            .navigationTitle("Payment")
            .navigationDestination(isPresented: $showSuccess) {
                PaymentSuccessPage()
            }
            .navigationDestination(isPresented: $showAddCard) {
                AddCardPage()
            }
        }
    }

    // MARK: - Views

    func cardView(_ card: PaymentCard) -> some View {
        HStack {
            Text("\(card.brand) •••• \(card.last4)")
                .font(.system(size: 16, weight: .medium))

            Spacer()

            Button("Change") {
                showAddCard = true
            }
            .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    var addCardPrompt: some View {
        Button {
            showAddCard = true
        } label: {
            HStack {
                Image(systemName: "creditcard")
                Text("Add payment card")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Logic

    func pay() {
        paymentStore.processPayment(amount: product.price) { result in
            if case .success = result {
                showSuccess = true
            }
        }
    }
}
