//
//  ProfilePage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI
import FirebaseAuth

struct ProfilePage: View {
    @ObservedObject private var userStore = UserStore.shared

    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Header
                    profileHeader

                    // MARK: - Account Section
                    sectionCard {
                        profileRow(
                            title: "My Orders",
                            systemImage: "bag",
                            destination: OrdersPage()
                        )

                        Divider()

                        profileRow(
                            title: "Wishlist",
                            systemImage: "heart",
                            destination: WishlistPage()
                        )
                    }

                    // MARK: - Payments & Address
                    sectionCard {
                        profileRow(
                            title: "Payment Methods",
                            systemImage: "creditcard",
                            destination: PaymentMethodsPage()
                        )

                        Divider()

                        profileRow(
                            title: "Shipping Addresses",
                            systemImage: "location",
                            destination: AddressesPage()
                        )
                    }

                    // MARK: - Support
                    sectionCard {
                        profileRow(
                            title: "Settings",
                            systemImage: "gearshape",
                            destination: SettingsPage()
                        )

                        Divider()

                        profileRow(
                            title: "Help & Support",
                            systemImage: "questionmark.circle",
                            destination: SupportChatView()
                        )
                    }

                    // MARK: - Logout
                    logoutButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}

private extension ProfilePage {

    var profileHeader: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(accentGreen.opacity(0.15))
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 28))
                        .foregroundColor(accentGreen)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(userStore.currentUser?.username ?? "Guest User")
                    .font(.headline)

                Text(userStore.currentUser?.email ?? "guest@example.com")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
private extension ProfilePage {

    func sectionCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
private extension ProfilePage {

    func profileRow<Destination: View>(
        title: String,
        systemImage: String,
        destination: Destination
    ) -> some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .foregroundColor(accentGreen)
                    .frame(width: 24)

                Text(title)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            .padding()
        }
    }
}


private extension ProfilePage {

    var logoutButton: some View {
        Button {
            logOut()
        } label: {
            Text("Log Out")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(16)
        }
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .first?.delegate as? SceneDelegate {
                
                let authContainer = AuthContainerVC()
                let navController = UINavigationController(rootViewController: authContainer)
                navController.navigationBar.isHidden = true
                
                UIView.transition(with: sceneDelegate.window!,
                                  duration: 0.5,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                    sceneDelegate.window?.rootViewController = navController
                })
            }
        } catch let error {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
}

//TODO: - gaitane mere da gaaswore
struct PaymentMethodsPage: View { var body: some View { Text("Payments") } }
struct AddressesPage: View { var body: some View { Text("Addresses") } }
struct SettingsPage: View { var body: some View { Text("Settings") } }

