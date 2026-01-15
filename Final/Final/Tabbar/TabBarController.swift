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
    
    static var shared: TabBarController?
    
    private let customTabBarHeight: CGFloat = 70
    private let floatingMargin: CGFloat = 22
    private var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        TabBarController.shared = self
        setupTabs()
        setupCustomTabBarAppearance()
    }

    private func setupTabs() {
        let homeVC = UIHostingController(rootView: HomePage())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let exploreVC = UIHostingController(rootView: ExplorePage())
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let cartVC = UIHostingController(rootView: CartPage())
        cartVC.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 2)
        
        let profileVC = UIHostingController(rootView: ProfilePage())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 3)
        
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: exploreVC),
            UINavigationController(rootViewController: cartVC),
            UINavigationController(rootViewController: profileVC)
        ]
    }
    
    func switchToProfileTab() {
        self.selectedIndex = 3
    }
    
    private func setupCustomTabBarAppearance() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
        tabBar.tintColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1)
        tabBar.unselectedItemTintColor = .white

        backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = UIColor(.gray.opacity(0.6))
        backgroundView.layer.cornerRadius = customTabBarHeight / 2
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.15
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backgroundView.layer.shadowRadius = 10
        view.addSubview(backgroundView)
        view.bringSubviewToFront(tabBar)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = tabBar.frame.width - 40
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
