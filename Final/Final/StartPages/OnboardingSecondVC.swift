//
//  OnboardingSecondVC.swift
//  Final
//
//  Created by nika kovziridze on 06.01.26.
//

import UIKit

final class OnboardingSecondVC: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover our collections"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let googleButton = UIButton(type: .system)
    private let emailButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupButtons()
        setupLayout()
    }
    
    private func setupButtons() {
        googleButton.setTitle("Sign in with Google", for: .normal)
        emailButton.setTitle("Sign in with Email", for: .normal)
        
        googleButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        emailButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            googleButton,
            emailButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .center
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}
#Preview {
    OnboardingPageVC()
}
