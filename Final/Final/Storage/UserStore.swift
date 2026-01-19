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
    @Published var showOrderNotification = false
    
    private var listener: ListenerRegistration?
    
    private init() {}
    
    func fetchUser(uid: String, completion: ((UserModel) -> Void)? = nil) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error {
                print("Error fetching user:", error)
                return
            }
            
            if let snapshot, snapshot.exists,
               let user = try? snapshot.data(as: UserModel.self) {
                self.currentUser = user
                completion?(user)
                return
            }
            
            guard let firebaseUser = Auth.auth().currentUser else { return }
            let newUser = UserModel(
                id: firebaseUser.uid,
                username: firebaseUser.displayName ?? "New User",
                email: firebaseUser.email ?? "",
                city: "",
                cart: [],
                favorites: []
            )
            
            do {
                try userRef.setData(from: newUser) { err in
                    if let err = err {
                        print("Error creating user:", err)
                    } else {
                        self.currentUser = newUser
                        completion?(newUser)
                    }
                }
            } catch {
                print("Error encoding user:", error)
            }
        }
    }


    
    func stopListening() {
        listener?.remove()
    }
    
    func updateCart(item: CartItem) {
        guard let uid = currentUser?.id else { return }

        var updatedCart = currentUser?.cart ?? []
        if let index = updatedCart.firstIndex(where: { $0.id == item.id }) {
            updatedCart[index].quantity = item.quantity
        } else {
            updatedCart.append(item)
        }
        
        currentUser?.cart = updatedCart

        let cartDicts = updatedCart.map { ["id": $0.id, "quantity": $0.quantity] }
        Firestore.firestore().collection("users").document(uid).updateData([
            "cart": cartDicts
        ])
    }
    // remove after purchase
    func removePurchasedItems(_ items: [CartDisplayItem]) {
        guard let user = currentUser else { return }

        let updatedCart = user.cart.filter { cartItem in
            !items.contains(where: { $0.id == cartItem.id })
        }

        currentUser?.cart = updatedCart

        let cartDicts = updatedCart.map { ["id": $0.id, "quantity": $0.quantity] }
        Firestore.firestore()
            .collection("users")
            .document(user.id ?? "")
            .updateData(["cart": cartDicts])
    }


}
extension UserStore {
    func toggleFavorite(productID: Int) {
        guard let uid = currentUser?.id else { return }

        var updatedFavorites = currentUser?.favorites ?? []

        if let index = updatedFavorites.firstIndex(of: "\(productID)") {
            updatedFavorites.remove(at: index)
        } else {
            updatedFavorites.append("\(productID)")
        }
        currentUser?.favorites = updatedFavorites

        Firestore.firestore().collection("users").document(uid)
            .updateData(["favorites": updatedFavorites]) { error in
                if let error = error {
                    print("Error updating favorites:", error)
                } else {
                    print("Favorites updated successfully")
                }
            }
    }

    func isFavorite(productID: Int) -> Bool {
        currentUser?.favorites.contains("\(productID)") ?? false
    }
}
//MARK: - saving order logic
extension UserStore {

    func saveOrder(items: [CartDisplayItem], address: Address, totalAmount: Double, completion: ((Bool) -> Void)? = nil, showNotification: (() -> Void)? = nil) {
        guard let uid = currentUser?.id else { return }

        let db = Firestore.firestore()
        let orderID = UUID().uuidString
        let order = Order(id: orderID, items: items, address: address, totalAmount: totalAmount)

        // Save in "users/{uid}/orders/{orderID}"
        do {
            try db.collection("users")
                .document(uid)
                .collection("orders")
                .document(orderID)
                .setData(from: order) { error in
                    if let error = error {
                        print("Failed to save order:", error)
                        completion?(false)
                    }
                    self.fetchOrders { orders in
                        self.currentUser?.orders = orders
                        completion?(true)
                        
                        showNotification?()
                    }
                }
        } catch {
            print("Failed to encode order:", error)
            completion?(false)
        }
    }

    func fetchOrders(completion: @escaping ([Order]) -> Void) {
        guard let uid = currentUser?.id else {
            print("No UID")
            completion([])
            return
        }

        let db = Firestore.firestore()

        db.collection("users")
            .document(uid)
            .collection("orders")
            .getDocuments { snapshot, error in

                if let error = error {
                    print("Firestore error:", error)
                    completion([])
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents")
                    completion([])
                    return
                }

                print("Firestore documents count:", documents.count)

                let orders = documents.compactMap { doc -> Order? in
                    do {
                        return try doc.data(as: Order.self)
                    } catch {
                        print("Decoding failed for doc \(doc.documentID):", error)
                        return nil
                    }
                }

                completion(orders)
            }
    }

}

extension UserStore {
    func updateOrderStatus(orderID: String, status: String) {
        guard let uid = currentUser?.id else { return }

        if let index = currentUser?.orders.firstIndex(where: { $0.id == orderID }) {
            currentUser?.orders[index].status = status
        }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("orders")
            .document(orderID)
            .updateData(["status": status])
    }
}

