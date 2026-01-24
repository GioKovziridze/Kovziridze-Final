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
        label.text = "Find out your style here"
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemIndigo.cgColor,
            UIColor.purple.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        label.font = UIFont(name: "AvenirNext-Bold", size: 30)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.shadowColor = UIColor.black.withAlphaComponent(0.25)
        label.shadowOffset = CGSize(width: 1, height: 1)
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
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOpacity = 0.3
        image.layer.shadowRadius = 20
        image.layer.shadowOffset = CGSize(width: 0, height: 10)
        return image
    }()

    private lazy var nextButtonContainer: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 28
        blurView.clipsToBounds = true
        
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        blurView.layer.shadowColor = UIColor.black.cgColor
        blurView.layer.shadowOpacity = 0.2
        blurView.layer.shadowRadius = 12
        blurView.layer.shadowOffset = CGSize(width: 0, height: 6)
        
        return blurView
    }()

    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(
            systemName: "chevron.right",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        )
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 56).isActive = true
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        
        // Gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemIndigo.cgColor, UIColor.purple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
        gradientLayer.cornerRadius = 28
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        // Shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 12
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        
        return button
    }()

    private let bottomContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        // Gradient overlay
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemIndigo.withAlphaComponent(0.8).cgColor,
            UIColor.purple.withAlphaComponent(0.9).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 32
        view.layer.insertSublayer(gradient, at: 0)
        
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Premium background gradient
        let bgGradient = CAGradientLayer()
        bgGradient.frame = view.bounds
        bgGradient.colors = [
            UIColor.systemIndigo.cgColor,
            UIColor.purple.cgColor
        ]
        bgGradient.startPoint = CGPoint(x: 0, y: 0)
        bgGradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(bgGradient, at: 0)
        
        configureImage()
        setupContainer()
        setupBottomLayout()
    }

    
    private func setupBottomLayout() {
        nextButtonContainer.contentView.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButtonContainer.widthAnchor.constraint(equalToConstant: 56),
            nextButtonContainer.heightAnchor.constraint(equalTo: nextButtonContainer.widthAnchor),
            nextButton.centerXAnchor.constraint(equalTo: nextButtonContainer.contentView.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: nextButtonContainer.contentView.centerYAnchor)
        ])
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, nextButtonContainer])
        stack.axis = .vertical
        stack.spacing = 32
        stack.alignment = .center
        
        bottomContainer.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 40),
            stack.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor)
        ])
    }

    private func configureImage() {
        view.addSubview(modelImage)
        NSLayoutConstraint.activate([
            modelImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -200),
            modelImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modelImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupContainer() {
        view.addSubview(bottomContainer)
        NSLayoutConstraint.activate([
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
    }
}
