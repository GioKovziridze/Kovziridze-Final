//
//  RegistrationViewModel.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation
import Combine

final class RegistrationViewModel {
    
    // MARK: - Output Closures for UIKit
    var onError: ((String) -> Void)?
    var onSuccess: ((UserModel) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Dependencies
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    // MARK: - Registration Method
    func register(
        username: String?,
        email: String?,
        city: String?,
        password: String?,
        confirmPassword: String?
    ) {
        // Reset previous error
        onError?("")
        
        do {
            try AuthValidator.validateRegistration(
                username: username,
                email: email,
                city: city,
                password: password,
                confirmPassword: confirmPassword
            )
        } catch let error as AuthValidationError {
            onError?(error.errorDescription ?? "Validation error")
            return
        } catch {
            onError?("Unknown validation error")
            return
        }
        
        performRegistration(
            username: username,
            email: email,
            city: city,
            password: password
        )
    }
    
    // MARK: - Private Registration Helper
    private func performRegistration(
        username: String?,
        email: String?,
        city: String?,
        password: String?
    ) {
        onLoading?(true)
        
        let request = RegistrationRequest(
            username: username,
            email: email,
            city: city,
            password: password
        )
        
        networkManager.registerUser(request)
            .flatMap { success -> AnyPublisher<UserModel, Error> in
                guard success, let email = email, let password = password else {
                    return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Registration failed"])).eraseToAnyPublisher()
                }
                return NetworkManager.shared.loginUser(email: email, password: password)
            }
                        
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


