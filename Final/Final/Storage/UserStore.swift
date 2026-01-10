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
