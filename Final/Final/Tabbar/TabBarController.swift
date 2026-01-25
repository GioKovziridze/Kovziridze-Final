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
        
        let supportVC = UIHostingController(rootView: SupportChatView())
        supportVC.tabBarItem = UITabBarItem(title: "Support", image: UIImage(systemName: "message.fill"), tag: 2)
        
        let cartVC = UIHostingController(rootView: CartPage())
        cartVC.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 3)
        
        let profileVC = UIHostingController(rootView: ProfilePage())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 4)
        
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: exploreVC),
            UINavigationController(rootViewController: supportVC),
            UINavigationController(rootViewController: cartVC),
            UINavigationController(rootViewController: profileVC)
        ]
    }
    
    func switchToProfileTab() {
        self.selectedIndex = 4
    }
    func switchToExploreTab() {
        self.selectedIndex = 1
    }
    
    private func setupCustomTabBarAppearance() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
        tabBar.tintColor = UIColor.systemIndigo
        tabBar.unselectedItemTintColor = UIColor.systemIndigo.withAlphaComponent(0.45)
        
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = 0
        tabBar.itemWidth = 60
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold),
            .foregroundColor: UIColor.systemIndigo
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemIndigo
        

        backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = UIColor(
            red: 0.97, green: 0.97, blue: 0.99, alpha: 0.9
        )
        backgroundView.layer.cornerRadius = customTabBarHeight / 2
        backgroundView.layer.shadowColor = UIColor.systemIndigo.cgColor
        backgroundView.layer.shadowOpacity = 0.25
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 8)
        backgroundView.layer.shadowRadius = 18
        view.addSubview(backgroundView)
        view.bringSubviewToFront(tabBar)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let horizontalMargin: CGFloat = 40
        let width = tabBar.frame.width - (horizontalMargin * 2)
        let height = customTabBarHeight
        let x: CGFloat = horizontalMargin
        let y = view.frame.height - height - floatingMargin
        
        backgroundView.frame = CGRect(x: x, y: y, width: width, height: height)
        tabBar.frame = CGRect(x: horizontalMargin, y: y, width: width, height: height)
    }
}
#Preview{
    TabBarController()
}
