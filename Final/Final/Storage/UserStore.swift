//
//  UserStore.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

final class UserStore: ObservableObject {
    static let shared = UserStore()
    
    @Published var currentUser: UserModel?
    
    private var listener: ListenerRegistration?
    
    private init() {}
    
    func fetchUser(uid: String) {
        let db = Firestore.firestore()
        listener = db.collection("users").document(uid)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let snapshot = snapshot, snapshot.exists else { return }
                let data = snapshot.data()!
                let user = UserModel(
                    id: uid,
                    username: data["username"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    city: data["city"] as? String ?? "",
                    cart: (data["cart"] as? [[String: Any]] ?? []).compactMap {
                        guard let id = $0["id"] as? String,
                              let quantity = $0["quantity"] as? Int else { return nil }
                        return CartItem(id: id, quantity: quantity)
                    },
                    favorites: data["favorites"] as? [String] ?? []
                )
                self?.currentUser = user
            }
    }
    
    func stopListening() {
        listener?.remove()
    }
    
    func updateCart(item: CartItem) {
        guard let uid = currentUser?.id else { return }
        var updatedCart = currentUser?.cart ?? []
        if let index = updatedCart.firstIndex(where: { $0.id == item.id }) {
            updatedCart[index] = item
        } else {
            updatedCart.append(item)
        }
        
        let cartDicts = updatedCart.map { ["id": $0.id, "quantity": $0.quantity] }
        
        Firestore.firestore().collection("users").document(uid).updateData([
            "cart": cartDicts
        ])
    }
}
