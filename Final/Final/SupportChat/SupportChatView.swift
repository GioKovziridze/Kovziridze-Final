//
//  SupportChatView.swift
//  Final
//
//  Created by nika kovziridze on 20.01.26.
//

import SwiftUI

struct SupportChatView: View {
    
    @StateObject private var viewModel = SupportChatViewModel()
    
    private let userGradient = LinearGradient(
        colors: [Color.indigo, Color(red: 0.22, green: 0.18, blue: 0.35)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    private let assistantBubble = Color(.secondarySystemBackground)
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(viewModel.messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                        
                        if viewModel.isLoading {
                            typingIndicator
                        }
                    }
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            inputBar
        }
    }
    
    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("Ask support…", text: $viewModel.input)
                .padding(12)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            Button {
                viewModel.send()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(userGradient)
                    .clipShape(Circle())
            }
            .disabled(viewModel.input.isEmpty || viewModel.isLoading)
        }
        .padding()
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea(edges: .bottom)
        )
    }
    private var typingIndicator: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
                .frame(width: 60, height: 28)
                .overlay(
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.7)
                )
            Spacer()
        }
        .padding(.leading)
    }
}
