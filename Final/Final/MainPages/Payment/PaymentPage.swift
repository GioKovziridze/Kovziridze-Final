//
//  PaymentPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI

struct PaymentPage: View {
    let products: [CartDisplayItem]
    let selectedAddress: Address?
    var nextAction: () -> Void
    
    @ObservedObject private var paymentStore = PaymentStore.shared

    @State private var showAddCard = false
    @State private var showSavedCards = false
    @State private var showSuccess = false
    @State private var isPaymentSuccessful = false
    
    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)

    var totalAmount: Double {
        products.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 24) {

                // MARK: - Order Summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Order Summary")
                        .font(.headline)

                    ForEach(products) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.product.title)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                Text("Quantity: \(item.quantity)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("$\(item.product.price * Double(item.quantity), specifier: "%.2f")")
                                .fontWeight(.semibold)
                        }
                    }

                    Divider()

                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text("$\(totalAmount, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
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
                            .background(accentGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        Text("Pay now")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(paymentStore.selectedCard == nil ? Color.gray : accentGreen)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .disabled(paymentStore.selectedCard == nil || paymentStore.isProcessing)
                

            }
            .padding()
            .navigationTitle("Payment")
            
            if isPaymentSuccessful {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                
                PaymentSuccessPage(nextAction: nextAction)
                    .transition(.scale.combined(with: .opacity))
            }
            
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPaymentSuccessful)
        .navigationDestination(isPresented: $showAddCard) {
            AddCardPage()
        }
        .navigationDestination(isPresented: $showSavedCards) {
            SavedCardsPage()
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
                    .foregroundColor(accentGreen)
                Text("Add another card")
                    .foregroundColor(accentGreen)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(accentGreen.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Show cards button
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
        paymentStore.processPayment(amount: totalAmount) {
            if let selectedAddress = selectedAddress {
                UserStore.shared.saveOrder(
                    items: products,
                    address: selectedAddress,
                    totalAmount: totalAmount
                ) { success in
                    if success {
                        print("Order saved successfully")
                        
                        UserStore.shared.removePurchasedItems(products)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                            GlobalNotificationManager.shared.show(
                                message: "Order arriving! Track your order."
                            )
                        }
                    }
                }
            }
            isPaymentSuccessful = true
        }
    }

}
