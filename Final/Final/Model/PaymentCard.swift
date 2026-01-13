//
//  PaymentCard.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import Foundation

struct PaymentCard: Identifiable, Codable {
    let id = UUID()
    let last4: String
    let brand: String
}
