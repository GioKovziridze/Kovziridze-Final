//
//  AddCardPage.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import SwiftUI

struct AddCardPage: View {
    
    @ObservedObject private var paymentStore = PaymentStore.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvc = ""
    @State private var cardHolder = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case cardNumber, expiryDate, cvc, cardHolder
    }
    
    @State private var flipDegree = 0.0
    
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
                                .opacity(flipDegree < 90 ? 1 : 0)
                            
                            backCard
                                .opacity(flipDegree >= 90 ? 1 : 0)
                        }
                    )
                    .rotation3DEffect(
                        .degrees(flipDegree),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(.easeInOut(duration: 0.5), value: flipDegree)
            }
            .padding(.horizontal)
            
            // MARK: - Text Fields
            VStack(spacing: 16) {
                TextField("Card Number", text: $cardNumber)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .cardNumber)
                    .onChange(of: cardNumber) { newValue in
                        cardNumber = filterNumbers(input: newValue, limit: 16)
                    }
                    .onChange(of: focusedField) { _ in updateFlip() }
                
                TextField("Cardholder Name", text: $cardHolder)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.allCharacters) // auto uppercase
                    .focused($focusedField, equals: .cardHolder)
                    .onChange(of: cardHolder) { newValue in
                        cardHolder = newValue.uppercased()
                    }
                    .onChange(of: focusedField) { _ in updateFlip() }
                
                HStack {
                    TextField("MM/YY", text: $expiryDate)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField, equals: .expiryDate)
                        .onChange(of: expiryDate) { newValue in
                            expiryDate = formatExpiry(input: newValue)
                        }
                        .onChange(of: focusedField) { _ in updateFlip() }
                    
                    TextField("CVC", text: $cvc)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField, equals: .cvc)
                        .onChange(of: cvc) { newValue in
                            cvc = filterNumbers(input: newValue, limit: 3)
                        }
                        .onChange(of: focusedField) { _ in updateFlip() }
                }
            }
            .padding(.horizontal)
            
            // MARK: - Add Card Button
            Button {
                paymentStore.addMockCard()
                dismiss()
            } label: {
                Text("Add Card")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
    
    // MARK: - Front Card View
    var frontCard: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(LinearGradient(colors: [Color.blue, Color.blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(height: 200)
            .shadow(radius: 5)
            .overlay(
                VStack(alignment: .leading, spacing: 16) {
                    Text("Card Number")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(cardNumber.isEmpty ? "•••• •••• •••• ••••" : formattedCardNumber(cardNumber))
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Expiry")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text(expiryDate.isEmpty ? "MM/YY" : expiryDate)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("CVC")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text(cvc.isEmpty ? "•••" : cvc)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text(cardHolder.isEmpty ? "CARDHOLDER NAME" : cardHolder)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        // Visa logo placeholder (replace with your image)
                        Image(.visa)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 30)
                            .foregroundColor(.white)
                    }
                }
                .padding()
            )
    }
    
    // MARK: - Back Card View
    var backCard: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(LinearGradient(colors: [Color.gray.opacity(0.8), Color.gray], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(height: 200)
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
                                Text(cvc.isEmpty ? "•••" : cvc)
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                            )
                            .padding(.leading, 200)
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            )
    }
    
    // MARK: - Helpers
    func formattedCardNumber(_ number: String) -> String {
        let trimmed = number.replacingOccurrences(of: " ", with: "")
        var result = ""
        for (index, char) in trimmed.enumerated() {
            if index != 0 && index % 4 == 0 { result += " " }
            result.append(char)
        }
        return result
    }
    
    func filterNumbers(input: String, limit: Int) -> String {
        let filtered = input.filter { $0.isNumber }
        return String(filtered.prefix(limit))
    }
    
    func formatExpiry(input: String) -> String {
        let filtered = input.filter { $0.isNumber }
        var result = ""
        for (index, char) in filtered.prefix(4).enumerated() {
            if index == 2 { result += "/" }
            result.append(char)
        }
        return result
    }
    
    func updateFlip() {
        withAnimation(.easeInOut(duration: 0.5)) {
            flipDegree = (focusedField == .cvc) ? 180 : 0
        }
    }
}

#Preview{
    AddCardPage()
}

