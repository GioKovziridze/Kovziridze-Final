//
//  AddressStep.swift
//  Final
//
//  Created by nika kovziridze on 15.01.26.
//
import SwiftUI
import MapKit

struct AddressStep: View {
    @Binding var selectedAddress: Address?
    var nextAction: () -> Void
    
    @State private var addressText: String = ""
    
    private let accentGreen = Color(red: 0.45, green: 0.78, blue: 0.62)
    
    var body: some View {
        VStack(spacing: 16) {
            
            // MARK: - Title
            Text("Select your delivery address")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - Draggable Map
            DraggableMapView(selectedAddress: $selectedAddress)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // MARK: - Optional Manual Address Input
            TextField("Enter address manually", text: $addressText)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // MARK: - Next Button
            Button {
                saveAddress()
                nextAction()
            } label: {
                Text("Next")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(accentGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(selectedAddress == nil && addressText.isEmpty)
        }
        .padding()
    }
    
    // MARK: - Save Address
    private func saveAddress() {
        // If user typed manually but didn't tap map
        if selectedAddress == nil {
            // Use default Tbilisi coordinates
            let defaultCoordinate = CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271)
            selectedAddress = Address(coordinate: defaultCoordinate, addressLine: addressText)
        } else if !addressText.isEmpty {
            // Update the addressLine from text
            selectedAddress?.addressLine = addressText
        }
    }
}

// MARK: - Address Model
struct Address: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var addressLine: String
}
