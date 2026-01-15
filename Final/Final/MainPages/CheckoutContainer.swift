//
//  CheckoutContainer.swift
//  Final
//
//  Created by nika kovziridze on 15.01.26.
//

import SwiftUI
import MapKit

struct CheckoutContainer: View {
    @State private var currentStep: CheckoutStep = .address
    @State private var selectedAddress: Address?
    
    let cartItems: [CartDisplayItem]
    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)

    var body: some View {
        NavigationStack {
            VStack {
                // Progress Indicator
                stepIndicator
                
                Divider().padding(.vertical, 8)
                
                // Step Content
                Group {
                    switch currentStep {
                    case .address:
                        AddressStep(selectedAddress: $selectedAddress, nextAction: goToPayment)
                    case .payment:
                        PaymentPage(products: cartItems, nextAction: goToTracking)
                    case .tracking:
                        OrderTrackingPage()
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: currentStep)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Step Indicator
    private var stepIndicator: some View {
        HStack {
            stepCircle(step: .address, title: "Address")
            stepLine()
            stepCircle(step: .payment, title: "Payment")
            stepLine()
            stepCircle(step: .tracking, title: "Tracking")
        }
        .padding(.bottom)
    }
    
    private func stepCircle(step: CheckoutStep, title: String) -> some View {
        VStack {
            ZStack {
                Circle()
                    .fill(currentStep == step || currentStep.rawValue > step.rawValue ? accentGreen : Color.gray.opacity(0.3))
                    .frame(width: 28, height: 28)
                if currentStep.rawValue > step.rawValue {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("\(step.rawValue + 1)")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            Text(title)
                .font(.caption)
        }
    }
    
    private func stepLine() -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 2)
            .frame(maxWidth: .infinity)
    }
    
    // MARK: - Step Navigation
    private func goToPayment() {
        currentStep = .payment
    }
    
    private func goToTracking() {
        guard selectedAddress != nil else { return }
        currentStep = .tracking
    }
}

enum CheckoutStep: Int {
    case address = 0
    case payment = 1
    case tracking = 2
}

