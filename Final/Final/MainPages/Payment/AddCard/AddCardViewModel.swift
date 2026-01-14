//
//  AddCardViewModel.swift
//  Final
//
//  Created by nika kovziridze on 14.01.26.
//
import SwiftUI
import Combine

enum CardBrand: String, CaseIterable {
    case mastercard = "MasterCard"
    case visa = "Visa"
    case amex = "Amex"
    
    var imageName: String {
        switch self {
        case .mastercard: return "mastercard"
        case .visa: return "visa"
        case .amex: return "amex"
        }
    }
}

final class AddCardViewModel: ObservableObject {

    // MARK: - Properties
    @Published var cardNumber = ""
    @Published var expiryDate = ""
    @Published var cvc = ""
    @Published var cardHolder = ""
    @Published var flipDegree = 0.0
    @Published var cardBrand: CardBrand = .mastercard
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
    
        paymentStore.addCard(
            last4: last4,
            holderName: cardHolder,
            expMonth: month,
            expYear: year,
            brand: cardBrand.rawValue
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
    
    private func detectCardBrand() {
        guard let firstDigit = cardNumber.first else {
            cardBrand = .mastercard
            return
        }
        
        switch firstDigit {
        case "4":
            cardBrand = .visa
        case "5":
            cardBrand = .mastercard
        case "3":
            cardBrand = .amex
        default:
            cardBrand = .mastercard
        }
    }
    
    private func clearSensitiveFields() {
        cardNumber = ""
        cvc = ""
        expiryDate = ""
    }
    
    
}
