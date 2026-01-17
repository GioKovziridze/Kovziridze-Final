//
//  OrdersPage.swift
//  Final
//
//  Created by nika kovziridze on 17.01.26.
//

import SwiftUI

struct OrdersPage: View {
    @ObservedObject private var userStore = UserStore.shared

    var body: some View {
        List {
            if userStore.currentUser?.orders.isEmpty ?? true {
                Text("No orders yet.")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                ForEach(userStore.currentUser!.orders) { order in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Order ID: \(order.id)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Total: $\(order.totalAmount, specifier: "%.2f")")
                            .font(.headline)
                        
                        Text("Status: \(order.status)")
                            .font(.subheadline)
                            .foregroundColor(order.status == "Pending" ? .orange : .green)
                        
                        Text("Date: \(order.date.formatted(.dateTime.month().day().year()))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(8)
                }
            }
        }
        .navigationTitle("My Orders")
        .onAppear {
            userStore.fetchOrders { orders in
                print("Fetched \(orders.count) orders")
            }
        }
    }
}

