//
//  PaymentStore.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI
import FirebaseCore

final class PaymentStore: ObservableObject {

    static let shared = PaymentStore()

    @Published var cards: [PaymentCard] = []
    @Published var selectedCard: PaymentCard?
    @Published var isProcessing = false

    private let repository = CardManager()

    private init() {}

    // MARK: - Load
    func loadCards() {
        repository.fetchCards { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let cards) = result {
                    self?.cards = cards
                    if self?.selectedCard == nil {
                        self?.selectedCard = cards.first
                    }
                }
            }
        }
    }

    // MARK: - Select
    func selectCard(_ card: PaymentCard) {
        selectedCard = card
    }

    // MARK: - Add
    func addCard(
        last4: String,
        holderName: String,
        expMonth: Int,
        expYear: Int,
        brand: String
    ) {
        let card = PaymentCard(
            last4: last4,
            holderName: holderName,
            expMonth: expMonth,
            expYear: expYear,
            brand: brand,
            createdAt: Timestamp()
        )

        repository.addCard(card) { [weak self] result in
            if case .success = result {
                self?.loadCards()
            }
        }
    }

    // MARK: - Delete
    func deleteCard(_ card: PaymentCard) {
        guard let cardId = card.id else { return }

        repository.deleteCard(cardId: cardId) { [weak self] result in
            DispatchQueue.main.async {
                if case .success = result {
                    self?.cards.removeAll { $0.id == cardId }

                    if self?.selectedCard?.id == cardId {
                        self?.selectedCard = self?.cards.first
                    }
                }
            }
        }
    }

    // MARK: - Mock Payment
    func processPayment(amount: Double, completion: @escaping () -> Void) {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isProcessing = false
            completion()
        }
    }
}
