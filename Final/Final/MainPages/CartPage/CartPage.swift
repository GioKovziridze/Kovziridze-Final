//
//  CartPage.swift
//  Final
//
//  Created by nika kovziridze on 14.01.26.
//

import SwiftUI
import FirebaseFirestore

struct CartPage: View {
    @StateObject private var viewModel = CartViewModel()
    @ObservedObject private var userStore = UserStore.shared
    @ObservedObject private var productStore = ProductStore.shared
    

    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.items.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.items) { item in
                                cartItemRow(item)
                            }
                        }
                        .padding()
                    }

                    checkoutSection
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Cart")
            .onAppear {
                reloadCart()
            }
            .onChange(of: userStore.currentUser?.cart) { _ in
                reloadCart()
            }
        }
    }

    private func reloadCart() {
        guard let user = userStore.currentUser else { return }
        viewModel.buildCart(user: user, products: productStore.products)
    }
}

private extension CartPage {

    func cartItemRow(_ item: CartDisplayItem) -> some View {
        HStack(spacing: 12) {

            Image(item.product.image)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .background(Color.white)
                .cornerRadius(12)
                .scaledToFill()

            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.title)
                    .font(.subheadline)
                    .lineLimit(2)

                Text("$\(item.product.price, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(accentGreen)

                viewModel.quantityControls(item)
            }

            Spacer()

            Button {
                viewModel.removeItem(item)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
}

private extension CartPage {

    var checkoutSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Total")
                    .font(.headline)

                Spacer()

                Text("$\(viewModel.totalPrice, specifier: "%.2f")")
                    .font(.title3)
                    .foregroundColor(accentGreen)
            }

            NavigationLink{
                CheckoutContainer(cartItems: viewModel.items)
            } label: {
                Text("Buy Now")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(accentGreen)
                    .cornerRadius(16)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 12)
    }
    
    var emptyState: some View {
        VStack(spacing: 24) {
            Image(systemName: "cart.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [accentGreen, accentGreen.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(1.1)
                .padding()
                .background(
                    Circle()
                        .fill(accentGreen.opacity(0.1))
                        .frame(width: 120, height: 120)
                )
                .shadow(color: accentGreen.opacity(0.3), radius: 10, x: 0, y: 5)
                .animation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                    value: UUID()
                )
            
            Text("Your Cart is Empty")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Add products to start shopping and discover amazing deals!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: {
                TabBarController.shared?.switchToExploreTab()
            }) {
                Text("Start Shopping")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [accentGreen, accentGreen.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: accentGreen.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 30)
    }

}

