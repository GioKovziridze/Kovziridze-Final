//
//  OrderTrackingPage.swift
//  Final
//
//  Created by nika kovziridze on 15.01.26.
//


import SwiftUI

struct OrderTrackingPreviewPage: View {
    @State private var currentStep: TrackingStep = .confirmed
    @Environment(\.dismiss) private var dismiss

    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)

    var body: some View {
        VStack(spacing: 24) {
            
            // MARK: - Page Title
            Text("Track Your Order")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Order ")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - Progress Timeline
            VStack(spacing: 32) {
                ForEach(TrackingStep.allCases, id: \.self) { step in
                    timelineStep(step: step)
                }
            }
            .padding(.top)
            
            Spacer()
            
            // MARK: - Delivery Estimate
            VStack(spacing: 8) {
                Text("Estimated Delivery")
                    .font(.headline)
                Text("Jan 20, 2026")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(accentGreen.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.black)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Timeline Step
    private func timelineStep(step: TrackingStep) -> some View {
        HStack(alignment: .top) {
            ZStack {
                Circle()
                    .fill(currentStep.rawValue >= step.rawValue ? accentGreen : Color.gray.opacity(0.3))
                    .frame(width: 24, height: 24)
                
                if currentStep.rawValue > step.rawValue {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(.headline)
                Text(step.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 8)
            
            Spacer()
        }
    }
}

// MARK: - Tracking Steps
enum TrackingStep: Int, CaseIterable {
    case confirmed = 0
    case preparing
    case shipped
    case delivered
    
    var title: String {
        switch self {
        case .confirmed: return "Order Confirmed"
        case .preparing: return "Preparing for Shipment"
        case .shipped: return "Shipped"
        case .delivered: return "Delivered"
        }
    }
    
    var subtitle: String {
        switch self {
        case .confirmed: return "We received your order."
        case .preparing: return "Your items are being packed."
        case .shipped: return "Your order is on the way."
        case .delivered: return "Your order has been delivered."
        }
    }
}

// MARK: - Preview
struct OrderTrackingPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OrderTrackingPreviewPage()
        }
    }
}
