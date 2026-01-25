//
//  SavedCardsPage.swift
//  Final
//
//  Created by nika kovziridze on 15.01.26.
//


import SwiftUI

struct SavedCardsPage: View {
    @ObservedObject private var paymentStore = PaymentStore.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        if paymentStore.cards.isEmpty {
            VStack {
                Spacer()
                Text("No saved cards yet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .navigationTitle("My Cards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                paymentStore.loadCards()
            }
        } else {
            List {
                ForEach(paymentStore.cards) { card in
                    cardRow(card)
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("My Cards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                paymentStore.loadCards()
            }
            
        }
    }

    // MARK: - Card Row
    private func cardRow(_ card: PaymentCard) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(card.brand) •••• \(card.last4)")
                    .font(.system(size: 16, weight: .medium))

                Text("Expires \(card.expMonth)/\(card.expYear)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if paymentStore.selectedCard?.id == card.id {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            paymentStore.selectCard(card)
            dismiss()
        }
    }

    // MARK: - Delete
    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let card = paymentStore.cards[index]
            paymentStore.deleteCard(card)
        }
    }
}
