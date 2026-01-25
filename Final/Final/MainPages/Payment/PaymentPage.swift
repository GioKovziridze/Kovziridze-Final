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
    
    private let brandIndigo = Color.indigo
    private let softBackground = Color(red: 0.98, green: 0.98, blue: 1.0)
    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)

    var totalAmount: Double {
        products.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    var body: some View {
        ZStack {
            softBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    orderSummaryCard
                    
                    paymentSection
                    
                    payButton
                }
                .padding()
            }
            
            if isPaymentSuccessful {
                Color.black.opacity(0.35).ignoresSafeArea()
                PaymentSuccessPage(nextAction: nextAction)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .navigationBarBackButtonHidden(true)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPaymentSuccessful)
        .navigationDestination(isPresented: $showAddCard) {
            AddCardPage()
        }
        .navigationDestination(isPresented: $showSavedCards) {
            SavedCardsPage()
        }
    }
    
    var paymentSection: some View {
        VStack(spacing: 14) {

            Text("Payment Method")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let selectedCard = paymentStore.selectedCard {
                cardView(selectedCard)
                addCardButton
            } else {
                addCardPrompt
                showCardsButton
            }
        }
    }


    // MARK: - Card Row
    func cardView(_ card: PaymentCard) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(card.brand) •••• \(card.last4)")
                    .font(.system(size: 16, weight: .semibold))

                Text("Expires \(card.expMonth)/\(card.expYear)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button("Change") {
                showSavedCards = true
            }
            .font(.subheadline)
            .foregroundColor(Color.indigo)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.indigo.opacity(0.08), radius: 10, x: 0, y: 6)
    }

    var orderSummaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Order Summary")
                .font(.headline)

            ForEach(products) { item in
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.product.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(2)

                        Text("Qty \(item.quantity)")
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
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.indigo)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: Color.indigo.opacity(0.08), radius: 14, x: 0, y: 8)
    }

    // MARK: - Add Card Prompt (full-width button)
    var addCardPrompt: some View {
        Button {
            showAddCard = true
        } label: {
            HStack {
                Image(systemName: "creditcard.fill")
                Text("Add Payment Card")
                    .fontWeight(.semibold)
            }
            .foregroundColor(brandIndigo)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(brandIndigo.opacity(0.4), lineWidth: 1.5)
            )
        }
    }


    // MARK: - Add Card button
    var addCardButton: some View {
        Button {
            showAddCard = true
        } label: {
            Text("Add another card")
                .fontWeight(.semibold)
                .foregroundColor(Color.indigo)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.indigo.opacity(0.1))
                .cornerRadius(16)
        }
    }

    // MARK: - Show cards button
    var showCardsButton: some View {
        Button {
            showSavedCards = true
        } label: {
            Text("Show My Cards")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.indigo.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }

    var payButton: some View {
        Button {
            pay()
        } label: {
            if paymentStore.isProcessing {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text("Pay $\(totalAmount, specifier: "%.2f")")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .foregroundColor(.white)
        .background(
            LinearGradient(
                colors: paymentStore.selectedCard == nil
                    ? [Color.gray, Color.gray.opacity(0.7)]
                    : [Color.indigo, Color.indigo.opacity(0.75)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.indigo.opacity(0.4), radius: 12, x: 0, y: 8)
        .disabled(paymentStore.selectedCard == nil || paymentStore.isProcessing)
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
