//
//  AddCardViewModel.swift
//  Final
//
//  Created by nika kovziridze on 14.01.26.
//
import SwiftUI
import Combine

final class AddCardViewModel: ObservableObject {

    // MARK: - Properties
    @Published var cardNumber = ""
    @Published var expiryDate = ""
    @Published var cvc = ""
    @Published var cardHolder = ""
    @Published var flipDegree = 0.0
    @Published var errorMessage: String?

    private let paymentStore = PaymentStore.shared

    // MARK: - Actions
    func addCard(completion: @escaping () -> Void) {

        guard isFormValid else {
            errorMessage = "Please fill in all card details correctly."
            return
        }

        let last4 = String(cardNumber.suffix(4))
        let (month, year) = parseExpiry(expiryDate)
        let brand = detectBrand(from: cardNumber)

        paymentStore.addCard(
            last4: last4,
            holderName: cardHolder,
            expMonth: month,
            expYear: year,
            brand: brand
        )
        clearSensitiveFields()

        completion()
    }

    func updateFlip(focusedField: AddCardPage.Field?) {
        withAnimation(.easeInOut(duration: 0.5)) {
            flipDegree = focusedField == .cvc ? 180 : 0
        }
    }

    // MARK: - Formatting Helpers
    func processCardNumber(_ input: String) {
        let filtered = input.filter(\.isNumber)
        cardNumber = String(filtered.prefix(16))
    }

    func processCVC(_ input: String) {
        let filtered = input.filter(\.isNumber)
        cvc = String(filtered.prefix(3))
    }

    func processExpiry(_ input: String) {
        let filtered = input.filter(\.isNumber)
        var result = ""
        for (index, char) in filtered.prefix(4).enumerated() {
            if index == 2 { result.append("/") }
            result.append(char)
        }
        expiryDate = result
    }

    var formattedCardDisplay: String {
        guard !cardNumber.isEmpty else {
            return "•••• •••• •••• ••••"
        }

        return stride(from: 0, to: cardNumber.count, by: 4).map {
            let start = cardNumber.index(cardNumber.startIndex, offsetBy: $0)
            let end = cardNumber.index(start, offsetBy: min(4, cardNumber.count - $0))
            return String(cardNumber[start..<end])
        }.joined(separator: " ")
    }

    // MARK: - Validation
    var isFormValid: Bool {
        cardNumber.count == 16 &&
        cvc.count == 3 &&
        expiryDate.count == 5 &&
        !cardHolder.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func parseExpiry(_ expiry: String) -> (Int, Int) {
        let components = expiry.split(separator: "/")
        let month = Int(components.first ?? "") ?? 0
        let year = 2000 + (Int(components.last ?? "") ?? 0)
        return (month, year)
    }

    private func detectBrand(from number: String) -> String {
        switch number.first {
        case "4": return "Visa"
        case "5": return "MasterCard"
        case "3": return "American Express"
        case "6": return "Discover"
        default: return "Unknown"
        }
    }

    private func clearSensitiveFields() {
        cardNumber = ""
        cvc = ""
        expiryDate = ""
    }
}
