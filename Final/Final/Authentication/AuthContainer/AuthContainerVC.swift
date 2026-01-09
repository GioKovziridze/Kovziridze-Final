//
//  AuthContainerVC.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//
import UIKit
import Foundation

final class AuthContainerVC: UIViewController {

    private let viewModel = AuthContainerViewModel()

    private let authSwitch = AuthSwitchView()
    private let containerView = UIView()

    private let loginVC = LoginVC(viewModel: LoginViewModel())
    private let registerVC = RegistrationVC(viewModel: RegistrationViewModel())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        bindViewModel()
        show(loginVC)
    }

    private func setupUI() {
        authSwitch.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(authSwitch)
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            authSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            authSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authSwitch.widthAnchor.constraint(equalToConstant: 300),
            authSwitch.heightAnchor.constraint(equalToConstant: 64),

            containerView.topAnchor.constraint(equalTo: authSwitch.bottomAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bindViewModel() {

        // View → ViewModel
        authSwitch.onModeChange = { [weak self] mode in
            guard let self else { return }

            let vmMode: AuthContainerViewModel.Mode =
                mode == .login ? .login : .register

            self.viewModel.switchMode(vmMode)
        }

        // ViewModel → View
        viewModel.onModeChange = { [weak self] mode in
            guard let self else { return }

            switch mode {
            case .login:
                self.show(self.loginVC)
            case .register:
                self.show(self.registerVC)
            }
        }
    }

    private func show(_ vc: UIViewController) {
        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }

        addChild(vc)
        containerView.addSubview(vc.view)
        vc.view.frame = containerView.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: self)
    }
}
#Preview {
    AuthContainerVC()
}
