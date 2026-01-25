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
    private let indigo = Color.indigo
    private let deepPurple = Color(red: 0.22, green: 0.18, blue: 0.35)
    private let cardBackground = Color(.secondarySystemBackground)
    
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

                    // MARK: - Logout
                    logoutButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

private extension ProfilePage {

    var profileHeader: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [indigo, deepPurple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(userStore.currentUser?.username ?? "Guest User")
                    .font(.headline)
                    .foregroundColor(.white)

                Text(userStore.currentUser?.email ?? "guest@example.com")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
            }

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [indigo, deepPurple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: deepPurple.opacity(0.35), radius: 20, y: 10)
    }
}
private extension ProfilePage {

    func sectionCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .background(cardBackground)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.04))
        )
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
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .foregroundColor(indigo)
                    .frame(width: 24)

                Text(title)
                    .font(.body)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}


private extension ProfilePage {

    var logoutButton: some View {
        Button(role: .destructive) {
            logOut()
        } label: {
            Text("Log Out")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(cardBackground)
                .cornerRadius(16)
        }
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

