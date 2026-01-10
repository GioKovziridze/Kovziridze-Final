//
//  HomePage.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation
import SwiftUI

struct HomePage: View {
    @ObservedObject var userStore = UserStore.shared
    
    var body: some View {
        VStack(spacing: 20) {
            if let user = userStore.currentUser {
                Text("Welcome, \(user.username)!")
                    .font(.title)
                Text("City: \(user.city)")
                    .foregroundColor(.secondary)
                
                Text("Your Cart:")
                    .font(.headline)
                
                List(user.cart) { item in
                    HStack {
                        Text(item.id)
                        Spacer()
                        Text("Qty: \(item.quantity)")
                    }
                }
                
                Button("Add Sample Item") {
                    let sampleItem = CartItem(id: "product123", quantity: 1)
                    userStore.updateCart(item: sampleItem)
                }
            } else {
                Text("Welcome, guest!")
            }
        }
        .padding()
    }
}

