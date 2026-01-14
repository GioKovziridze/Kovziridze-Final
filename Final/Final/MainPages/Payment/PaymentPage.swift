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
    @State private var showSavedCards = false
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

                // MARK: - Payment Card Section
                if let selectedCard = paymentStore.selectedCard {
                    cardView(selectedCard)

                    addCardButton
                } else {
                    addCardPrompt
                    showCardsButton
                }

                Spacer()

                // MARK: - Pay Button
                Button {
                    pay()
                } label: {
                    if paymentStore.isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        Text("Pay now")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(paymentStore.selectedCard == nil ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
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
            .navigationDestination(isPresented: $showSavedCards) {
                SavedCardsPage()
            }
        }
    }

    // MARK: - Card Row
    func cardView(_ card: PaymentCard) -> some View {
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
                showSavedCards = true
            }
            .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Add Card Prompt (full-width button)
    var addCardPrompt: some View {
        Button {
            showAddCard = true
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                Text("Add Payment Card")
                    .fontWeight(.medium)
            }
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.blue, lineWidth: 1.5)
            )
        }
    }

    // MARK: - Add Card button
    var addCardButton: some View {
        Button {
            showAddCard = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
                Text("Add another card")
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    //MARK: - Show cards button
    var showCardsButton: some View {
        Button {
            showSavedCards = true
        } label: {
            Text("Show My Cards")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }


    // MARK: - Pay Logic
    func pay() {
        paymentStore.processPayment(amount: product.price) {
            showSuccess = true
        }
    }
}
