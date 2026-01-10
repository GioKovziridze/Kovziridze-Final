//
//  HomePage.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation
import SwiftUI

struct HomePage: View {
    @ObservedObject private var userStore = UserStore.shared
    @ObservedObject private var store = ProductStore.shared
    
    var body: some View {
        VStack(spacing: 20) {
            header
                .padding()
            promoBanner
            HStack{
                Text("Category")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Text("See all")
                    .foregroundColor(.black)
            }
            .padding()
            .task {
                await store.loadProducts()// Only needs to be called once
                print(store.products)
            }
        }
    }
    
    
    @ViewBuilder
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if let user = userStore.currentUser {
                    Text("Hello, \(user.username)!")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text("Location: \(user.city)")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                } else {
                    Text("Welcome, guest!")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }

            Spacer()

            Button {
                // favorite action
            } label: {
                Image(systemName: "heart")
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color(.lightGray).opacity(0.3))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
    
     var promoBanner: some View {
        HStack(spacing: 16) {

            // TEXT SIDE
            VStack(alignment: .leading, spacing: 8) {
                Text("Don’t miss out!")
                    .font(.subheadline)
                    .foregroundColor(.white)

                Text("Discover the latest collections\npicked just for you.")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .foregroundColor(.black.opacity(0.7))
            }

            Spacer()

            Image("model4")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 180)
                .offset(x: 0, y: 35)
        }
        .padding(16)
        .frame(width: 340, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gr1)
        )
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)
        .padding(.horizontal)
    }


}
//#Preview {
//    HomePage(userStore: UserStore.shared)
//}
    
