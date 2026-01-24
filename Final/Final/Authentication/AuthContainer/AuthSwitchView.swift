//
//  AuthSwitchView.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import UIKit

final class AuthSwitchView: UIView {

    enum Mode {
        case login
        case register
    }

    var onModeChange: ((Mode) -> Void)?

    private let backgroundView = UIView()
    private let selectorView = UIView()

    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)

    private var selectorLeadingConstraint: NSLayoutConstraint!

    private(set) var mode: Mode = .login

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        // MARK: - Background (capsule)
        backgroundView.backgroundColor = UIColor.systemGray6
        backgroundView.layer.cornerRadius = 32
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Selector
        selectorView.backgroundColor = UIColor(red: 0.29, green: 0.0, blue: 0.51, alpha: 0.7) 
        selectorView.layer.cornerRadius = 28
        selectorView.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Buttons
        loginButton.setTitle("Login", for: .normal)
        registerButton.setTitle("Register", for: .normal)

        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        registerButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        loginButton.setTitleColor(.label, for: .normal)
        registerButton.setTitleColor(.label, for: .normal)

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [loginButton, registerButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Hierarchy
        addSubview(backgroundView)
        backgroundView.addSubview(selectorView)
        backgroundView.addSubview(stack)

        // MARK: - Layout
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),

            selectorView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 6),
            selectorView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -6),
            selectorView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.5),

            stack.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
        ])

        selectorLeadingConstraint = selectorView.leadingAnchor.constraint(
            equalTo: backgroundView.leadingAnchor,
            constant: 6
        )
        selectorLeadingConstraint.isActive = true
    }

    // MARK: - Actions

    @objc private func loginTapped() {
        setMode(.login, animated: true)
    }

    @objc private func registerTapped() {
        setMode(.register, animated: true)
    }

    // MARK: - Public

    func setMode(_ mode: Mode, animated: Bool) {
        self.mode = mode

        let selectorX: CGFloat = mode == .login
            ? 6
            : bounds.width / 2 + 6

        selectorLeadingConstraint.constant = selectorX

        let animations = {
            self.layoutIfNeeded()
        }

        animated
        ? UIView.animate(withDuration: 0.25,
                         delay: 0,
                         usingSpringWithDamping: 0.9,
                         initialSpringVelocity: 0.4,
                         options: [.curveEaseOut],
                         animations: animations)
        : animations()

        onModeChange?(mode)
    }
}
