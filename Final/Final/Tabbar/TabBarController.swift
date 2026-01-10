//
//  TabBarController.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation
import UIKit
import SwiftUI

final class TabBarController: UITabBarController {

    private let customTabBarHeight: CGFloat = 70 // slim height
    private let floatingMargin: CGFloat = 22
    private var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupCustomTabBarAppearance()
    }

    private func setupTabs() {
        let homeVC = UIHostingController(rootView: HomePage())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let profileVC = UIViewController()
        profileVC.view.backgroundColor = .systemBackground
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        
        let cartVC = UIViewController()
        cartVC.view.backgroundColor = .systemBackground
        cartVC.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 2)
        
        let exploreVC = UIViewController()
        exploreVC.view.backgroundColor = .systemBackground
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: profileVC),
            UINavigationController(rootViewController: cartVC),
            UINavigationController(rootViewController: exploreVC)
        ]
    }

    private func setupCustomTabBarAppearance() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
        tabBar.tintColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1) // light green
        tabBar.unselectedItemTintColor = .lightGray

        // Add slim floating background
        backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = .darkGray
        backgroundView.layer.cornerRadius = customTabBarHeight / 2 // capsule shape
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.15
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backgroundView.layer.shadowRadius = 10
        view.addSubview(backgroundView)
        view.bringSubviewToFront(tabBar)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = tabBar.frame.width - 40 // 20pt padding each side
        let height = customTabBarHeight
        let x: CGFloat = 20
        let y = view.frame.height - height - floatingMargin

        backgroundView.frame = CGRect(x: x, y: y, width: width, height: height)
        tabBar.frame = CGRect(x: 0, y: view.frame.height - height - floatingMargin, width: view.frame.width, height: height)
    }
}
#Preview{
    TabBarController()
}
