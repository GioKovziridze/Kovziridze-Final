//
//  PaymentStore.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI

final class PaymentStore: ObservableObject {

    static let shared = PaymentStore()

    @Published var savedCard: PaymentCard? = nil
    @Published var isProcessing = false

    private init() {}

    // MOCK PAYMENT
    func processPayment(amount: Double, completion: @escaping (PaymentResult) -> Void) {
        isProcessing = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isProcessing = false
            completion(.success)
        }
    }

    func addMockCard() {
        savedCard = PaymentCard(
            last4: "4242",
            brand: "Visa"
        )
    }
}
