//
//  CartViewModel.swift
//  Final
//
//  Created by nika kovziridze on 14.01.26.
//

import SwiftUI
import FirebaseFirestore

final class CartViewModel: ObservableObject {
    @Published var items: [CartDisplayItem] = []
    
    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)
    
    func buildCart(
        user: UserModel,
        products: [Product]
    ) {
        items = user.cart.compactMap { cartItem -> CartDisplayItem? in
            guard let product = products.first(where: { String($0.id) == cartItem.id }) else {
                return nil
            }

            return CartDisplayItem(
                id: cartItem.id,
                product: product,
                quantity: cartItem.quantity
            )
        }
    }
    
    var totalPrice: Double {
        items.reduce(0) {
            $0 + ($1.product.price * Double($1.quantity))
        }
    }
    
    func quantityControls(_ item: CartDisplayItem) -> some View {
        HStack(spacing: 12) {
            Button {
                self.updateQuantity(item, delta: -1)
            } label: {
                Image(systemName: "minus")
            }

            Text("\(item.quantity)")
                .frame(minWidth: 20)

            Button {
                self.updateQuantity(item, delta: 1)
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
    func updateQuantity(_ item: CartDisplayItem, delta: Int) {
        let newQuantity = max(1, item.quantity + delta)

        let updatedItem = CartItem(
            id: item.id,
            quantity: newQuantity
        )

        UserStore.shared.updateCart(item: updatedItem)
    }
    func removeItem(_ item: CartDisplayItem) {
        guard let user = UserStore.shared.currentUser else { return }

        let updatedCart = user.cart.filter { $0.id != item.id }
        UserStore.shared.currentUser?.cart = updatedCart

        let cartDicts = updatedCart.map {
            ["id": $0.id, "quantity": $0.quantity]
        }

        Firestore.firestore()
            .collection("users")
            .document(user.id ?? "")
            .updateData(["cart": cartDicts])
    }
}

