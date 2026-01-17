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
        VStack {
            stepIndicator
            
            Divider().padding(.vertical, 8)
            
            Group {
                switch currentStep {
                case .address:
                    AddressStep(selectedAddress: $selectedAddress, nextAction: goToPayment)
                case .payment:
                    PaymentPage(
                        products: cartItems,
                        selectedAddress: selectedAddress,
                        nextAction: goToTracking
                    )
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("") {
                    goToPreviousStep()
                }
            }
        }

        
    }
    //TODO: - move these funcs
    
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
    
    private func goToPreviousStep() {
        withAnimation {
            switch currentStep {
            case .address:
                break
                
            case .payment:
                currentStep = .address
                
            case .tracking:
                currentStep = .payment
            }
        }
    }

}

enum CheckoutStep: Int {
    case address = 0
    case payment = 1
    case tracking = 2
}

