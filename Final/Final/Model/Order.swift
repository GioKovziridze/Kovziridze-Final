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

enum OrderStatus: String, CaseIterable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case preparing = "Preparing"
    case onTheWay = "On the Way"
    case nearby = "Nearby"
    case delivered = "Delivered"
}

extension Order {
    var progress: Double {
        let steps = OrderStatus.allCases.map { $0.rawValue }
        guard let index = steps.firstIndex(of: status) else { return 0 }
        return Double(index + 1) / Double(steps.count)
    }
}
