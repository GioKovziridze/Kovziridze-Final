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
    private let brandIndigo = Color.indigo
    private let softBackground = Color(red: 0.98, green: 0.98, blue: 1.0)
    private let destructiveRed = Color.red.opacity(0.85)


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
//            .navigationTitle("Cart")
//            .navigationBarTitleDisplayMode(.inline)
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
        HStack(spacing: 14) {

            Image(item.product.image)
                .resizable()
                .scaledToFill()
                .frame(width: 68, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(brandIndigo.opacity(0.15), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                Text("$\(item.product.price, specifier: "%.2f")")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(brandIndigo)

                viewModel.quantityControls(item)
            }

            Spacer()

            Button {
                viewModel.removeItem(item)
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(destructiveRed)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(brandIndigo.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: brandIndigo.opacity(0.06), radius: 10, x: 0, y: 6)
    }

}

private extension CartPage {
    
    var checkoutSection: some View {
        VStack(spacing: 18) {
            
            HStack {
                Text("Total")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("$\(viewModel.totalPrice, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(brandIndigo)
            }
            
            NavigationLink {
                CheckoutContainer(cartItems: viewModel.items)
            } label: {
                Text("Buy Now")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [brandIndigo, brandIndigo.opacity(0.75)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: brandIndigo.opacity(0.35), radius: 10, x: 0, y: 6)
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: brandIndigo.opacity(0.08), radius: 14, x: 0, y: 8)
    }
    
    
    var emptyState: some View {
        VStack(spacing: 22) {
            
            Image(systemName: "cart.fill")
                .font(.system(size: 56))
                .foregroundStyle(
                    LinearGradient(
                        colors: [brandIndigo, brandIndigo.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding()
                .background(
                    Circle()
                        .fill(brandIndigo.opacity(0.1))
                        .frame(width: 120, height: 120)
                )
                .shadow(color: brandIndigo.opacity(0.25), radius: 10, x: 0, y: 5)
            
            Text("Your Cart is Empty")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add products to start shopping and discover something you’ll love.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button {
                TabBarController.shared?.switchToExploreTab()
            } label: {
                Text("Start Shopping")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [brandIndigo, brandIndigo.opacity(0.75)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(14)
                    .shadow(color: brandIndigo.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(softBackground)
    }
}

