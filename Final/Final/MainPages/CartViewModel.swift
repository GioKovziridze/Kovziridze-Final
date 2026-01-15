//
//  CartViewModel.swift
//  Final
//
//  Created by nika kovziridze on 14.01.26.
//

import SwiftUI

final class CartViewModel: ObservableObject {

    @Published var items: [CartDisplayItem] = []

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
}

