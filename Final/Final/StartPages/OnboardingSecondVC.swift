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
        label.text = "Discover Our Collections"
        label.font = UIFont(name: "AvenirNext-Bold", size: 34)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.5
        label.layer.shadowRadius = 8
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Curated fashion for every occasion"
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.4
        label.layer.shadowRadius = 6
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
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
    
    private let overlayGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.4).cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        gradient.locations = [0, 0.25, 0.6, 1]
        return gradient
    }()
    
    private let bottomCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 24
        view.layer.shadowOffset = CGSize(width: 0, height: -8)
        
        return view
    }()
    
    private let authTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Join Us to Start Shopping"
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 22)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let authSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get access to exclusive collections and personalized recommendations"
        label.font = UIFont(name: "AvenirNext-Medium", size: 15)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let authButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
        
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 28
        
        button.layer.shadowColor = UIColor.systemIndigo.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 16
        
        return button
    }()
    
    private let decorativeDotsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupImage()
        setupTopContent()
        setupBottomCard()
        addDecorations()
        
        authButton.addTarget(self, action: #selector(goToAuthentication), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        overlayGradient.frame = collectionImage.bounds
    }
    
    @objc private func goToAuthentication() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        UIView.animate(withDuration: 0.1, animations: {
            self.authButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.authButton.transform = .identity
            }
        }
        
        onContinueTapped?()
    }
    
    private func setupImage() {
        view.addSubview(collectionImage)
        
        NSLayoutConstraint.activate([
            collectionImage.topAnchor.constraint(equalTo: view.topAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionImage.layer.addSublayer(overlayGradient)
    }
    
    private func setupTopContent() {
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 12
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textStack)
        
        NSLayoutConstraint.activate([
            textStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            textStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func setupBottomCard() {
        view.addSubview(bottomCard)
        
        let textStack = UIStackView(arrangedSubviews: [authTitleLabel, authSubtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 8
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        bottomCard.addSubview(textStack)
        bottomCard.addSubview(authButton)
        
        NSLayoutConstraint.activate([
            bottomCard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCard.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomCard.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),
            
            textStack.topAnchor.constraint(equalTo: bottomCard.topAnchor, constant: 32),
            textStack.leadingAnchor.constraint(equalTo: bottomCard.leadingAnchor, constant: 32),
            textStack.trailingAnchor.constraint(equalTo: bottomCard.trailingAnchor, constant: -32),
            
            authButton.leadingAnchor.constraint(equalTo: bottomCard.leadingAnchor, constant: 32),
            authButton.trailingAnchor.constraint(equalTo: bottomCard.trailingAnchor, constant: -32),
            authButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -36),
            authButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func addDecorations() {
        bottomCard.addSubview(decorativeDotsView)
        
        NSLayoutConstraint.activate([
            decorativeDotsView.trailingAnchor.constraint(equalTo: bottomCard.trailingAnchor, constant: 20),
            decorativeDotsView.topAnchor.constraint(equalTo: bottomCard.topAnchor, constant: -20),
            decorativeDotsView.widthAnchor.constraint(equalToConstant: 100),
            decorativeDotsView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let positions: [(CGFloat, CGFloat, CGFloat)] = [
            (20, 30, 40),
            (60, 10, 30),
            (50, 60, 35)
        ]
        
        for (x, y, size) in positions {
            let circle = UIView()
            circle.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.3)
            circle.layer.cornerRadius = size / 2
            circle.frame = CGRect(x: x, y: y, width: size, height: size)
            decorativeDotsView.addSubview(circle)
        }
    }
}

#Preview {
    OnboardingPageVC()
}
