//
//  Order.swift
//  Final
//
//  Created by nika kovziridze on 16.01.26.
//

import Foundation

struct Order: Codable, Identifiable {
    var id: String = UUID().uuidString
    var items: [CartDisplayItem]
    var address: Address
    var totalAmount: Double
    var date: Date = Date()
    var status: String = "Pending"
}
