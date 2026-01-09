//
//  LoginViewModel.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation
import Combine
import FirebaseAuth

final class LoginViewModel {
    
    // MARK: - Output Closures
    var onError: ((String) -> Void)?
    var onSuccess: ((UserModel) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    private let networkManager: NetworkManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    // MARK: - Login
    func login(email: String?, password: String?) {
        // Reset previous error
        onError?("")
        
        // Validate fields
        guard let email, !email.isEmpty,
              let password, !password.isEmpty else {
            onError?("Please fill in all fields")
            return
        }
        
        guard email.contains("@"), email.contains(".") else {
            onError?("Please enter a valid email")
            return
        }
        
        if password.count < 6 {
            onError?("Password must be at least 6 characters")
            return
        }
        
        // Show loading
        onLoading?(true)
        
        // Call NetworkManager
        networkManager.loginUser(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.onLoading?(false)
                switch completion {
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] userModel in
                UserStore.shared.currentUser = userModel
                self?.onSuccess?(userModel)
            }
            .store(in: &cancellables)
    }
}
