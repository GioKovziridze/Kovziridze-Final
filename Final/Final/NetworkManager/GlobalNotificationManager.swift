//
//  GlobalNotificationManager.swift
//  Final
//
//  Created by nika kovziridze on 21.01.26.
//

import UIKit
import SwiftUI

final class GlobalNotificationManager {

    static let shared = GlobalNotificationManager()
    private init() {}

    private var hostingController: UIHostingController<OrderNotificationView>?

    func show(message: String, duration: TimeInterval = 3) {

        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else { return }

        if hostingController != nil { return }

        let view = OrderNotificationView(
            message: message,
            action: {
                TabBarController.shared?.switchToProfileTab()
                self.dismiss()
            }
        )

        let host = UIHostingController(rootView: view)
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false

        window.addSubview(host.view)
        hostingController = host

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])

        host.view.transform = CGAffineTransform(translationX: 0, y: -150)
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 0.8) {
            host.view.transform = .identity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.dismiss()
        }
    }

    func dismiss() {
        guard let host = hostingController else { return }

        UIView.animate(withDuration: 0.25, animations: {
            host.view.transform = CGAffineTransform(translationX: 0, y: -150)
            host.view.alpha = 0
        }) { _ in
            host.view.removeFromSuperview()
            self.hostingController = nil
        }
    }
}
