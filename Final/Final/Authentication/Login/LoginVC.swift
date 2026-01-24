//
//  LoginVC.swift
//  Final
//
//  Created by nika kovziridze on 06.01.26.
//

import Foundation
import UIKit

final class LoginVC: UIViewController {

    // MARK: - ViewModel
    private let viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
   
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Step Into the Future\nof Shopping"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let emailField = UITextField.makeGlassTextField("Email Address")
    private let passwordField = UITextField.makeGlassTextField("Password", secure: true)

    private let rememberCheckBox = UIButton(type: .system)
    private let forgotPasswordButton = UIButton(type: .system)

    private let loginButton = UIButton(type: .system)
    private var spinner = UIActivityIndicatorView(style: .medium)

    private let googleButton = SocialButton(
        title: "Google",
        image: UIImage(named: "google")
    )

    private let appleButton = SocialButton(
        title: "Apple",
        image: UIImage(systemName: "applelogo")
    )

    private let bottomLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupScroll()
        setupUI()
        bindViewModel()
    }

    // MARK: - Setup

    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.axis = .vertical
        contentStack.spacing = 20

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48)
        ])
    }

    private func setupUI() {

        contentStack.addArrangedSubview(titleLabel)

        contentStack.setCustomSpacing(32, after: titleLabel)

        contentStack.addArrangedSubview(
            UIStackView.makeLabeledField(title: "Email Address", field: emailField)
        )

        contentStack.addArrangedSubview(
            UIStackView.makeLabeledField(title: "Password", field: passwordField)
        )

        contentStack.addArrangedSubview(rememberForgotRow())

        setupLoginButton()
        setupDivider()
        setupSocialButtons()
        setupBottomLabel()
    }

    private func rememberForgotRow() -> UIView {
        rememberCheckBox.setTitle(" Remember Me", for: .normal)
        rememberCheckBox.setImage(UIImage(systemName: "square"), for: .normal)
        rememberCheckBox.tintColor = .label
        rememberCheckBox.addTarget(self, action: #selector(toggleRemember), for: .touchUpInside)

        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        forgotPasswordButton.setTitleColor(.secondaryLabel, for: .normal)

        let row = UIStackView(arrangedSubviews: [
            rememberCheckBox,
            UIView(),
            forgotPasswordButton
        ])
        row.axis = .horizontal
        return row
    }

    private func setupLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        loginButton.backgroundColor = UIColor(red: 0.29, green: 0.0, blue: 0.51, alpha: 1)
        loginButton.layer.cornerRadius = 28
        loginButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        loginButton.setTitleColor(.black, for: .normal)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            spinner.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: -16)
        ])
        

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        contentStack.addArrangedSubview(loginButton)
    }

    private func setupDivider() {
        let label = UILabel()
        label.text = "Or continue with"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)

        contentStack.addArrangedSubview(label)
    }

    private func setupSocialButtons() {
        let stack = UIStackView(arrangedSubviews: [googleButton, appleButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        
        googleButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)

        contentStack.addArrangedSubview(stack)
    }
    
    @objc private func googleSignInTapped() {
        viewModel.signInWithGoogle(presenting: self)
    }

    private func setupBottomLabel() {
        bottomLabel.text = "Don’t have an account? Sign up"
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = .secondaryLabel
        bottomLabel.font = .systemFont(ofSize: 14)

        contentStack.addArrangedSubview(bottomLabel)
    }

    // MARK: - Actions

    @objc private func toggleRemember() {
        let isChecked = rememberCheckBox.currentImage == UIImage(systemName: "square")
        rememberCheckBox.setImage(
            UIImage(systemName: isChecked ? "checkmark.square.fill" : "square"),
            for: .normal
        )
    }

    @objc private func loginTapped() {
        viewModel.login(
            email: emailField.text,
            password: passwordField.text
        )
    }

    // MARK: - Bind

    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] userModel in
            guard let self = self else { return }
            UserStore.shared.currentUser = userModel
            
            let tabBar = TabBarController()
            self.navigationController?.setViewControllers([tabBar], animated: true)
        }

        viewModel.onError = { [weak self] message in
            guard let self = self else { return }
            if !message.isEmpty {
                self.showError(message)
            }
        }
        viewModel.onLoading = { [weak self] isLoading in
            self?.loginButton.isEnabled = !isLoading
            if isLoading {
                self?.spinner.startAnimating()
            } else {
                self?.spinner.stopAnimating()
            }
        }
      
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

#Preview {
    LoginVC(viewModel: LoginViewModel())
}
