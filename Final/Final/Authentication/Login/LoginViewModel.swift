//
//  LoginViewModel.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

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
        onError?("")
        
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
        
        onLoading?(true)

        networkManager.loginUser(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.onLoading?(false)
                if case let .failure(error) = completion {
                    self?.onError?(error.localizedDescription)
                }
            } receiveValue: { [weak self] userModel in
                guard let self = self else { return }
                
                // Save user to Firestore / fetch full UserModel
                UserStore.shared.fetchUser(uid: userModel.id ?? "") { fullUser in
                    self.onSuccess?(fullUser)
                }
            }
            .store(in: &cancellables)
    }
    

    // MARK: - Google Sign In
    func signInWithGoogle(presenting viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            onError?("Missing Google Client ID")
            return
        }
        
        onLoading?(true)
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            guard let self else { return }
            
            if let error {
                self.onLoading?(false)
                self.onError?(error.localizedDescription)
                return
            }
            
            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                self.onLoading?(false)
                self.onError?("Google sign-in failed")
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                guard let self else { return }
                self.onLoading?(false)
                
                if let error {
                    self.onError?(error.localizedDescription)
                    return
                }
                
                // Fetch user via UserStore
                if let uid = result?.user.uid {
                    UserStore.shared.fetchUser(uid: uid) { [weak self] userModel in
                        self?.onSuccess?(userModel)
                    }
                }
            }
        }
    }

}
