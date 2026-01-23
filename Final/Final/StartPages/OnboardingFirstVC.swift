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
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 28)
        label.shadowColor = UIColor.black.withAlphaComponent(0.3)
        label.shadowOffset = CGSize(width: 1, height: 1)

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
            systemName: "chevron.right",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 18,
                weight: .semibold
            )
        )
        button.setImage(image, for: .normal)
        button.tintColor = .label

        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true

        button.layer.cornerRadius = 24
        button.clipsToBounds = true

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        blurView.isUserInteractionEnabled = false
        blurView.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.insertSubview(blurView, at: 0)

        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 4)

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
        
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 32
        blurView.clipsToBounds = true
        
        let tintView = UIView()
        tintView.backgroundColor = UIColor(red: 0.1, green: 0.15, blue: 0.1, alpha: 0.3)
        tintView.layer.cornerRadius = 32
        tintView.clipsToBounds = true
        tintView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomContainer.addSubview(blurView)
        bottomContainer.addSubview(tintView)
        
        NSLayoutConstraint.activate([
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.34),
            
            blurView.topAnchor.constraint(equalTo: bottomContainer.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor),
            
            tintView.topAnchor.constraint(equalTo: bottomContainer.topAnchor),
            tintView.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor),
            tintView.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor),
            tintView.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor),
        ])
    }

}
#Preview {
    OnboardingFirstVC()
}
