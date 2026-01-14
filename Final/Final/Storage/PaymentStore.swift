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

    func loadCards() {
        repository.fetchCards { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let cards) = result {
                    self?.cards = cards
                    self?.selectedCard = cards.first
                }
            }
        }
    }

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

    // MOCK PAYMENT
    func processPayment(amount: Double, completion: @escaping () -> Void) {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isProcessing = false
            completion()
        }
    }
}

