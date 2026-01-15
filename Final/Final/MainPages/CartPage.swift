//
//  CartPage.swift
//  Final
//
//  Created by nika kovziridze on 14.01.26.
//

import SwiftUI
import FirebaseFirestore

struct CartPage: View {
    @StateObject private var viewModel = CartViewModel()
    @ObservedObject private var userStore = UserStore.shared
    @ObservedObject private var productStore = ProductStore.shared
    

    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.items.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.items) { item in
                                cartItemRow(item)
                            }
                        }
                        .padding()
                    }

                    checkoutSection
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Cart")
            .onAppear {
                reloadCart()
            }
            .onChange(of: userStore.currentUser?.cart) { _ in
                reloadCart()
            }
        }
    }

    private func reloadCart() {
        guard let user = userStore.currentUser else { return }
        viewModel.buildCart(user: user, products: productStore.products)
    }
}

private extension CartPage {

    func cartItemRow(_ item: CartDisplayItem) -> some View {
        HStack(spacing: 12) {

            Image(item.product.image)
                .frame(width: 70, height: 70)
                .background(Color.white)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.title)
                    .font(.subheadline)
                    .lineLimit(2)

                Text("$\(item.product.price, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(accentGreen)

                quantityControls(item)
            }

            Spacer()

            Button {
                removeItem(item)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
}

private extension CartPage {

    func quantityControls(_ item: CartDisplayItem) -> some View {
        HStack(spacing: 12) {
            Button {
                updateQuantity(item, delta: -1)
            } label: {
                Image(systemName: "minus")
            }

            Text("\(item.quantity)")
                .frame(minWidth: 20)

            Button {
                updateQuantity(item, delta: 1)
            } label: {
                Image(systemName: "plus")
            }
        }
        .font(.caption)
        .padding(6)
        .background(accentGreen.opacity(0.15))
        .cornerRadius(10)
        .foregroundColor(accentGreen)
    }
}

private extension CartPage {

    func updateQuantity(_ item: CartDisplayItem, delta: Int) {
        let newQuantity = max(1, item.quantity + delta)

        let updatedItem = CartItem(
            id: item.id,
            quantity: newQuantity
        )

        userStore.updateCart(item: updatedItem)
    }

    func removeItem(_ item: CartDisplayItem) {
        guard let user = userStore.currentUser else { return }

        let updatedCart = user.cart.filter { $0.id != item.id }
        userStore.currentUser?.cart = updatedCart

        let cartDicts = updatedCart.map {
            ["id": $0.id, "quantity": $0.quantity]
        }

        Firestore.firestore()
            .collection("users")
            .document(user.id ?? "")
            .updateData(["cart": cartDicts])
    }
}

private extension CartPage {

    var checkoutSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Total")
                    .font(.headline)

                Spacer()

                Text("$\(viewModel.totalPrice, specifier: "%.2f")")
                    .font(.title3)
                    .foregroundColor(accentGreen)
            }

            Button {
                print("Proceed to payment (mock)")
            } label: {
                Text("Buy Now")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(accentGreen)
                    .cornerRadius(16)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 12)
    }
}
private extension CartPage {

    var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 48))
                .foregroundColor(accentGreen)

            Text("Your cart is empty")
                .font(.headline)

            Text("Add products to start shopping")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
