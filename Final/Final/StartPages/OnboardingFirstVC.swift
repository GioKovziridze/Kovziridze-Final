//
//  OnboardingFirstVC.swift
//  Final
//
//  Created by nika kovziridze on 06.01.26.
//

import UIKit

class OnboardingFirstVC: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 32)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Discover fashion that matches your unique personality"
        return label
    }()
    
    private let modelImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "model3")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 300
        image.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        return image
    }()
    
    private let imageFadeMask = CAGradientLayer()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.systemIndigo, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
      
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 12
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.masksToBounds = false
        
        return button
    }()
    
    private let bottomContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let decorativeCircle1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 80
        return view
    }()
    
    private let decorativeCircle2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        view.layer.cornerRadius = 60
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundView
        configureImage()
        setupContainer()
        setupBottomLayout()
    }
    
    private func setupBottomLayout() {
        titleLabel.text = "Find Your Style"
        
        bottomContainer.addSubview(decorativeCircle1)
        bottomContainer.addSubview(decorativeCircle2)
        
        NSLayoutConstraint.activate([
            decorativeCircle1.widthAnchor.constraint(equalToConstant: 160),
            decorativeCircle1.heightAnchor.constraint(equalToConstant: 160),
            decorativeCircle1.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: 40),
            decorativeCircle1.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -30),
            
            decorativeCircle2.widthAnchor.constraint(equalToConstant: 120),
            decorativeCircle2.heightAnchor.constraint(equalToConstant: 120),
            decorativeCircle2.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: -20),
            decorativeCircle2.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: -40)
        ])
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 12
        textStack.alignment = .center
        
        let mainStack = UIStackView(arrangedSubviews: [textStack, nextButton])
        mainStack.axis = .vertical
        mainStack.spacing = 32
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        bottomContainer.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 56),
            
            mainStack.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 48),
            mainStack.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 32),
            mainStack.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -32),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -42)
        ])
        
        bottomContainer.sendSubviewToBack(decorativeCircle2)
        bottomContainer.sendSubviewToBack(decorativeCircle1)
    }
    
    private func configureImage() {
        view.addSubview(modelImage)
        NSLayoutConstraint.activate([
            modelImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -200),
            modelImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modelImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupContainer() {
        view.addSubview(bottomContainer)
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemIndigo.withAlphaComponent(0.95).cgColor,
            UIColor.purple.withAlphaComponent(0.98).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 32
        
        bottomContainer.layer.insertSublayer(gradient, at: 0)
        bottomContainer.layer.shadowColor = UIColor.black.cgColor
        bottomContainer.layer.shadowOpacity = 0.3
        bottomContainer.layer.shadowRadius = 20
        bottomContainer.layer.shadowOffset = CGSize(width: 0, height: -8)
        bottomContainer.layer.cornerRadius = 32
        bottomContainer.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.34)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = bottomContainer.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bottomContainer.bounds
        }
    }
}

#Preview {
    OnboardingFirstVC()
}
