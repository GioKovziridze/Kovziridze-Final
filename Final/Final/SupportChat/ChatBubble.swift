//
//  ChatBubble.swift
//  Final
//
//  Created by nika kovziridze on 23.01.26.
//
import SwiftUI 

struct ChatBubble: View {
    let message: ChatMessage
    private let userGradient = LinearGradient(
        colors: [Color.indigo, Color(red: 0.22, green: 0.18, blue: 0.35)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    private let assistantBubble = Color(.secondarySystemBackground)
    var body: some View {
        HStack {
            if message.role == .assistant {
                bubble
                Spacer()
            } else {
                Spacer()
                bubble
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
    
    private var bubble: some View {
        Text(message.text)
            .font(.body)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(background)
            .foregroundColor(foreground)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .frame(
                maxWidth: 280,
                alignment: message.role == .user ? .trailing : .leading
            )

    }
    
    private var background: some View {
        Group {
            if message.role == .user {
                userGradient
            } else {
                assistantBubble
            }
        }
    }
    
    private var foreground: Color {
        message.role == .user ? .white : .primary
    }
    
    private var shadow: Color {
        message.role == .user
        ? Color.indigo.opacity(0.25)
        : Color.black.opacity(0.05)
    }
}
