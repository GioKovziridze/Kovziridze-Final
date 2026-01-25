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
        ScrollView {
            VStack(spacing: 16) {

                if userStore.currentUser?.orders.isEmpty ?? true {
                    emptyState
                } else {
                    ForEach(userStore.currentUser!.orders) { order in
                        if order.status != "Delivered" {
                            NavigationLink {
                                OrderTrackingPage(order: order)
                            } label: {
                                OrderCard(order: order)
                            }
                        } else {
                            OrderCard(order: order)
                                .foregroundColor(.green.opacity(0.3))
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("My Orders")
        .onAppear {
            if userStore.currentUser?.orders.isEmpty == true {
                userStore.fetchOrders { orders in
                    userStore.currentUser?.orders = orders
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "shippingbox")
                .font(.largeTitle)
                .foregroundColor(.gray)

            Text("No orders yet")
                .font(.headline)

            Text("Your orders will appear here once you make a purchase.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.top, 80)
    }
}


