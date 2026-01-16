//
//  SearchBar.swift
//  Final
//
//  Created by nika kovziridze on 14.01.26.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
            
            TextField("Search products", text: $text)
                .foregroundColor(.black)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color(red: 0.55, green: 1.0, blue: 0.6))
        )
    }
}
