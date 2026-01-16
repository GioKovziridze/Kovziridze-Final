//
//  AddCardPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI

struct AddCardPage: View {
    @StateObject private var viewModel = AddCardViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    enum Field {
        case cardNumber, expiryDate, cvc, cardHolder
    }

    var body: some View {
        VStack(spacing: 24) {

            Text("Add Card")
                .font(.largeTitle)
                .fontWeight(.bold)

            // MARK: - Card Display
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.clear)
                    .frame(height: 230)
                    .overlay(
                        ZStack {
                            frontCard
                                .opacity(viewModel.flipDegree < 90 ? 1 : 0)

                            backCard
                                .opacity(viewModel.flipDegree >= 90 ? 1 : 0)
                        }
                    )
                    .rotation3DEffect(
                        .degrees(viewModel.flipDegree),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(.easeInOut(duration: 0.5), value: viewModel.flipDegree)
            }
            .padding(.horizontal)

            // MARK: - Text Fields
            VStack(spacing: 16) {

                TextField("Card Number", text: $viewModel.cardNumber)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .cardNumber)
                    .onChange(of: viewModel.cardNumber) {
                        viewModel.processCardNumber($0)
                    }

                TextField("Cardholder Name", text: $viewModel.cardHolder)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.characters)
                    .focused($focusedField, equals: .cardHolder)
                    .onChange(of: viewModel.cardHolder) {
                        viewModel.cardHolder = $0.uppercased()
                    }

                HStack {
                    TextField("MM/YY", text: $viewModel.expiryDate)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .expiryDate)
                        .onChange(of: viewModel.expiryDate) {
                            viewModel.processExpiry($0)
                        }

                    TextField("CVC", text: $viewModel.cvc)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .cvc)
                        .onChange(of: viewModel.cvc) {
                            viewModel.processCVC($0)
                        }
                }
            }
            .padding(.horizontal)
            .onChange(of: focusedField) {
                viewModel.updateFlip(focusedField: $0)
            }

            // MARK: - Error Message
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // MARK: - Add Card Button
            Button {
                viewModel.addCard {
                    dismiss()
                }
            } label: {
                Text("Add Card")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isFormValid ? Color.blue : Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal)
            .disabled(!viewModel.isFormValid)

            Spacer()
        }
        .padding(.top)
    }

    // MARK: - Front Card
    private var frontCard: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: [.black, Color.card],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 220)
            .shadow(radius: 5)
            .overlay(
                VStack(alignment: .leading, spacing: 14) {

                    Text(viewModel.cardBrand.rawValue)
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.bold)

                    HStack{
                        Text(viewModel.formattedCardDisplay)
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(viewModel.cardBrand.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 60)
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Expiry")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text(viewModel.expiryDate.isEmpty ? "MM/YY" : viewModel.expiryDate)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }

                        Spacer()
                    }

                    Spacer()

                    HStack {
                        Text(viewModel.cardHolder.isEmpty ? "CARDHOLDER NAME" : viewModel.cardHolder)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.subheadline)

                        Spacer()

                        Image(.cardChip)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding()
            )
    }

    // MARK: - Back Card
    private var backCard: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: [Color.or1, Color.or2],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 220)
            .shadow(radius: 5)
            .overlay(
                VStack {
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 40)
                        .padding(.top, 20)

                    Spacer()

                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: 80, height: 30)
                            .overlay(
                                Text(viewModel.cvc.isEmpty ? "•••" : viewModel.cvc)
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                            )
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            )
    }
}
#Preview{
    AddCardPage()
}
