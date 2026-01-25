//
//  Order.swift
//  Final
//
//  Created by nika kovziridze on 16.01.26.
//
import FirebaseFirestore
import Foundation

struct Order: Codable, Identifiable {
    var id: String = UUID().uuidString
    var items: [CartDisplayItem]
    var address: Address
    var totalAmount: Double
   
    @ServerTimestamp var date: Date?
      var status: String = "Pending"
}

enum OrderStatus: String, CaseIterable {
    case pending
    case confirmed
    case preparing
    case onTheWay
    case nearby
    case delivered
}

extension Order {
    var progress: Double {
        let steps = OrderStatus.allCases.map { $0.rawValue }
        guard let index = steps.firstIndex(of: status) else { return 0 }
        return Double(index + 1) / Double(steps.count)
    }
}
