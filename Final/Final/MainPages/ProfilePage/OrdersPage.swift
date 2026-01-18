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
            userStore.fetchOrders { orders in
                print("Fetched \(orders.count) orders")
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

//TODO: move this later

struct OrderCard: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack {
                Text("Order #\(order.id.prefix(6))")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                StatusPill(status: order.status)
            }

            ProgressView(value: progress)
                .tint(.blue)

            HStack {
                Text("Total")
                    .foregroundColor(.secondary)

                Spacer()

                Text("$\(order.totalAmount, specifier: "%.2f")")
                    .bold()
            }

            Text(order.date.formatted(.dateTime.month().day().year()))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 4)
    }

    private var progress: Double {
        let steps = ["Pending", "Confirmed", "Preparing", "On the Way", "Nearby", "Delivered"]
        guard let index = steps.firstIndex(of: order.status) else { return 0 }
        return Double(index + 1) / Double(steps.count)
    }
}

//TODO: move this too

struct StatusPill: View {
    let status: String

    var body: some View {
        Text(status)
            .font(.caption.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }

    private var color: Color {
        switch status {
        case "Delivered":
            return .green
        case "On the Way", "Nearby":
            return .blue
        case "Preparing", "Confirmed":
            return .orange
        default:
            return .gray
        }
    }
}
