//
//  SupportChatViewModel.swift
//  Final
//
//  Created by nika kovziridze on 20.01.26.
//
import Foundation
import GoogleGenerativeAI

enum APIKey {
    static let gemini = "AIzaSyDVYRuhplG2DAyjsNCUtD6zcmljs0hhwpI"
}

@MainActor
final class SupportChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var input = ""
    @Published var isLoading = false
    
    private var chatSession: Chat?
    
    private let model = GenerativeModel(
        name: "gemini-flash-latest",
        apiKey: "AIzaSyAohWiS0tQA5idzA66DkWBt6KgHKvUaiyo"
    )
    
    init() {
        self.chatSession = model.startChat(history: [])
    }
    
    func send() {
        let userText = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userText.isEmpty else { return }
        
        messages.append(ChatMessage(role: .user, text: userText))
        input = ""
        isLoading = true
        
        Task {
            do {
                guard let chat = chatSession else { return }
                
                let response = try await chat.sendMessage(userText)
                let reply = response.text ?? "Sorry, I couldn’t respond."
                
                messages.append(ChatMessage(role: .assistant, text: reply))
            } catch {
                messages.append(
                    ChatMessage(role: .assistant, text: " \(error.localizedDescription)")
                )
                print("Detailed Error: \(error)")
            }
            isLoading = false
        }
    }
}
