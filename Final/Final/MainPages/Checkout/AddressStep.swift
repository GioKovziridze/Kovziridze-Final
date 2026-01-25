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

    private let brandIndigo = Color.indigo
    private let softBackground = Color(red: 0.98, green: 0.98, blue: 1.0)

    var body: some View {
        VStack(spacing: 20) {

            // MARK: - Title
            VStack(alignment: .leading, spacing: 6) {
                Text("Delivery Address")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Move the map pin or enter your address manually")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // MARK: - Map Card
            VStack(spacing: 12) {
                DraggableMapView(selectedAddress: $selectedAddress, city: UserStore.shared.currentUser?.displayCity ?? "New York")
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(22)
            .shadow(color: brandIndigo.opacity(0.08), radius: 14, x: 0, y: 8)

            // MARK: - Manual Address Input
            VStack(alignment: .leading, spacing: 6) {
                Text("Address details (optional)")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                TextField("Apartment, floor, notes…", text: $addressText)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(brandIndigo.opacity(0.12), lineWidth: 1)
                    )
            }

            Spacer(minLength: 8)

            // MARK: - Next Button
            Button {
                saveAddress()
                nextAction()
            } label: {
                HStack {
                    Text("Continue")
                        .fontWeight(.semibold)

                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
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
                .cornerRadius(18)
                .shadow(color: brandIndigo.opacity(0.4), radius: 10, x: 0, y: 6)
            }
            .disabled(selectedAddress == nil && addressText.isEmpty)
            .opacity((selectedAddress == nil && addressText.isEmpty) ? 0.6 : 1)
        }
        .padding()
        .background(softBackground.ignoresSafeArea())
    }

    // MARK: - Save Address
    private func saveAddress() {
        if selectedAddress == nil {
            let defaultCoordinate = CLLocationCoordinate2D(
                latitude: 41.7151,
                longitude: 44.8271
            )
            selectedAddress = Address(
                coordinate: defaultCoordinate,
                addressLine: addressText
            )
        } else if !addressText.isEmpty {
            selectedAddress?.addressLine = addressText
        }
    }
}
