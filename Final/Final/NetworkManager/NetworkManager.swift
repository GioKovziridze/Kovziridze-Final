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
    private let productURL = "https://fakestoreapi.com/products"
    private let categoryURL = "https://fakestoreapi.com/products/categories"
   

    
    
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
                        "cart": [],
                        "favorites": []
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
    
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: productURL) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([Product].self, from: data)
    }
    
    func fetchCategories() async throws -> [Category] {
        guard let url = URL(string: categoryURL) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Category].self, from: data)
    }
    
}
