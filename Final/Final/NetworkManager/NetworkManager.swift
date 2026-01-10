//
//  NetworkManager.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

// MARK: - Network Protocol
protocol NetworkManagerProtocol {
    func registerUser(_ request: RegistrationRequest) -> AnyPublisher<Bool, Error>
    func loginUser(email: String, password: String) -> AnyPublisher<UserModel, Error>
}

// MARK: - NetworkManager Implementation
final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private init() {}
    
    private let db = Firestore.firestore()
    
    // MARK: - Register User
    func registerUser(_ request: RegistrationRequest) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            Auth.auth().createUser(withEmail: request.email!, password: request.password!) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = authResult?.user else {
                    promise(.success(false))
                    return
                }
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = request.username
                changeRequest.commitChanges { profileError in
                    if let profileError = profileError {
                        promise(.failure(profileError))
                        return
                    }

                    let userData: [String: Any] = [
                        "username": request.username ?? "",
                        "email": request.email ?? "",
                        "city": request.city ?? "",
                        "cart": [],        // Empty cart initially
                        "favorites": []    // Empty favorites initially
                    ]
                    
                    self.db.collection("users").document(user.uid).setData(userData) { firestoreError in
                        if let firestoreError = firestoreError {
                            promise(.failure(firestoreError))
                        } else {
                            // Registration successful with Firestore
                            promise(.success(true))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Login User
    func loginUser(email: String, password: String) -> AnyPublisher<UserModel, Error> {
        Future<UserModel, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = authResult?.user else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                    return
                }
                
                self.db.collection("users").document(user.uid).getDocument { snapshot, firestoreError in
                    if let firestoreError = firestoreError {
                        promise(.failure(firestoreError))
                        return
                    }
                    
                    guard let snapshot = snapshot, snapshot.exists,
                          let data = snapshot.data() else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user data"])))
                        return
                    }
                    
                    let userModel = UserModel(
                        id: user.uid,
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
                    
                    promise(.success(userModel))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
