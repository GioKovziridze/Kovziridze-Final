//
//  ProductDetailsPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//


import SwiftUI

struct ProductDetailsPage: View {
    let product: Product
    let productStore = ProductStore.shared
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Image(product.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .background(Color.gray.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .padding(.horizontal)

                    Text(product.title)
                        .font(.system(size: 22, weight: .semibold))
                        .padding(.horizontal)

                    HStack {
                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.system(size: 24, weight: .bold))

                        Spacer()

                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", product.rating.rate))
                                .fontWeight(.semibold)
                            Text("(\(product.rating.count))")
                                .foregroundColor(.gray)
                        }
                        .font(.system(size: 14))
                    }
                    .padding(.horizontal)

                    Text(product.category.displayName)
                        .font(.system(size: 13, weight: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.55, green: 1.0, blue: 0.6).opacity(0.4))
                        )
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)

                        Text(product.description)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 100)
                }
                .padding(.top)
            }
            .scrollIndicators(.hidden)

            addToCartBar
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Bottom Bar
    private var addToCartBar: some View {
        VStack {
            Spacer()

            HStack {
                VStack(alignment: .leading) {
                    Text("Price")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)

                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.system(size: 18, weight: .bold))
                }

                Spacer()

                HStack(spacing: 12) {
                    Button {
                        addToCart(product)
                    } label: {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(.darkGray))
                            .frame(width: 48, height: 48)
                            .background(
                                Circle()
                                    .stroke(Color(.darkGray), lineWidth: 1)
                            )
                    }

                    NavigationLink {
                        PaymentPage(product: product)
                    } label: {
                        Text("Buy now")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.55, green: 1.0, blue: 0.6))
                            )
                    }
                    .buttonStyle(.plain)
                }

            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
}
extension ProductDetailsPage {
    
    func addToCart(_ product: Product) {
        let userStore = UserStore.shared

        let cartItem = CartItem(
            id: String(product.id),
            quantity: 1
        )

        userStore.updateCart(item: cartItem)
    }
}
