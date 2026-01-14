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

                // MARK: - Order Summary
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

                // MARK: - Card Section
                if let card = paymentStore.selectedCard {
                    cardView(card)
                } else {
                    addCardPrompt
                }

                Spacer()

                // MARK: - Pay Button
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
                .background(paymentStore.selectedCard == nil ? Color.gray : Color.green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .disabled(paymentStore.selectedCard == nil || paymentStore.isProcessing)
            }
            .padding()
            .navigationTitle("Payment")
            .navigationDestination(isPresented: $showSuccess) {
                PaymentSuccessPage()
            }
            .navigationDestination(isPresented: $showAddCard) {
                AddCardPage()
            }
            .onAppear {
                paymentStore.loadCards()
            }
        }
    }

    // MARK: - Card View
    private func cardView(_ card: PaymentCard) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(card.brand) •••• \(card.last4)")
                    .font(.system(size: 16, weight: .medium))

                Text("Expires \(card.expMonth)/\(card.expYear)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

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

    // MARK: - Add Card Prompt
    private var addCardPrompt: some View {
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

    // MARK: - Payment Logic
    private func pay() {
        paymentStore.processPayment(amount: product.price) {
            showSuccess = true
        }
    }
}
