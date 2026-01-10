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
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
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

    private lazy var nextButtonContainer: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        let size: CGFloat = 56
        blurView.layer.cornerRadius = size / 2
        blurView.clipsToBounds = true
        
        blurView.layer.borderWidth = 0.5
        blurView.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        
        return blurView
    }()

    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        
        let image = UIImage(
            systemName: "arrowtriangle.right.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        )
        
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
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


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackground
        configureImage()
        setupContainer()
        setupBottomLayout()
    }

    
    private func setupBottomLayout() {
        titleLabel.text = "Find out your style here"
        
        nextButtonContainer.contentView.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButtonContainer.widthAnchor.constraint(equalToConstant: 56),
            nextButtonContainer.heightAnchor.constraint(equalTo: nextButtonContainer.widthAnchor),
            
            nextButton.centerXAnchor.constraint(equalTo: nextButtonContainer.contentView.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: nextButtonContainer.contentView.centerYAnchor)
        ])
        
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            nextButtonContainer
        ])
        
        stack.axis = .vertical
        stack.spacing = 28
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
            modelImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            
        ])
    }
    private func setupContainer() {
        view.addSubview(bottomContainer)
        
        NSLayoutConstraint.activate([
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.34)
        ])
    }
}
#Preview {
    OnboardingFirstVC()
}
