//
//  PaymentCard.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import Foundation
import FirebaseFirestore

struct PaymentCard: Identifiable, Codable {
    @DocumentID var id: String?
    let last4: String
    let holderName: String
    let expMonth: Int
    let expYear: Int
    let brand: String
    let createdAt: Timestamp
}

