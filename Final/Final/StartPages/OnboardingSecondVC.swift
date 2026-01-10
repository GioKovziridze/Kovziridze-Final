//
//  OnboardingSecondVC.swift
//  Final
//
//  Created by nika kovziridze on 06.01.26.
//

import UIKit

final class OnboardingSecondVC: UIViewController {
    
    var onContinueTapped: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Discover our collections"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let collectionImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .collection
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
        
    }()

    private let authTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Join us to start shopping"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let authButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        // Glass-like look
        button.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor

        // Soft shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 16

        return button
    }()

    private var stackForButtons: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .center
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupImage()
        setupLabel()
        setupLayout()
        
        authButton.addTarget(self, action: #selector(goToAuthentication), for: .touchUpInside)
    }
    
    @objc private func goToAuthentication() {
        onContinueTapped?() 
    }
    
    private func setupImage() {
        view.addSubview(collectionImage)
        
        NSLayoutConstraint.activate([
            collectionImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionImage.heightAnchor.constraint(equalTo: view.heightAnchor),
            collectionImage.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    private func setupLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupLayout() {
        view.addSubview(authTitleLabel)
        view.addSubview(authButton)
        
        NSLayoutConstraint.activate([
            authButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            authButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            authButton.heightAnchor.constraint(equalToConstant: 56),
            
            authTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authTitleLabel.bottomAnchor.constraint(equalTo: authButton.topAnchor, constant: -16)
        ])
    }
}
#Preview {
    OnboardingPageVC()
}
