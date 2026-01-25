//
//  SupportChatViewModel.swift
//  Final
//
//  Created by nika kovziridze on 20.01.26.
//
import Foundation
import GoogleGenerativeAI

enum APIKey {
    static var gemini: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["GEMINI_API_KEY"] as? String else {
            fatalError("Missing GEMINI_API_KEY in Config.plist")
        }
        return key
    }
}

@MainActor
final class SupportChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var input = ""
    @Published var isLoading = false
    
    private var chatSession: Chat?
    
    private let systemPrompt = """
        You are a friendly and professional customer support agent for an e-commerce shopping app. Your goal is to help users with their shopping experience, orders, and account questions.
        
        **Your Capabilities:**
        - Check order status and history
        - Help with order tracking and delivery information
        - Assist with cart and checkout issues
        - Answer questions about favorites/wishlist
        - Help with account-related queries
        - Process order cancellations or modifications (if needed)
        - Provide product recommendations and shopping assistance
        
        **Communication Style:**
        - Be warm, friendly, and empathetic
        - Keep responses concise and easy to read
        - Use natural, conversational language (not robotic)
        - Show genuine care for the customer's concerns
        - Be proactive in offering solutions
        
        **Guidelines:**
        1. When users ask about orders, politely ask for their order ID if they haven't provided it
        2. If you need to check specific information, acknowledge that you're looking it up
        3. For complaints or issues, empathize first, then provide solutions
        4. Always confirm important actions before suggesting them
        5. End conversations by asking "Is there anything else I can help you with?"
        
        **Common Scenarios to Handle:**
        - "Where is my order?" → Ask for order ID and provide status
        - "I want to cancel my order" → Acknowledge and explain the process
        - "My cart isn't working" → Troubleshoot cart issues
        - "How do I add to favorites?" → Explain the feature
        - "I didn't receive my order" → Show empathy and investigate
        
        **Tone Examples:**
         "I'd be happy to help you track your order! Could you share your order ID with me?"
         "I completely understand your frustration. Let me look into this right away."
         "Great question! Here's how that works..."
        
         "I am a support bot. Please provide order number."
         "I cannot help with that request."
        
        Remember: You're the face of our brand. Make every interaction helpful and pleasant!
        """
    
    private let model = GenerativeModel(
        name: "gemini-flash-latest",
        apiKey: APIKey.gemini
    )
    
    init() {
        self.chatSession = model.startChat(
            history: [
                ModelContent(role: "user", parts: systemPrompt),
                ModelContent(role: "model", parts: "I understand! I'm ready to assist customers with their shopping experience. I'll be friendly, helpful, and professional while helping with orders, cart issues, favorites, and general inquiries. I'll make sure to ask for specific information like order IDs when needed and always maintain a warm, conversational tone. How can I help the first customer?")
            ]
        )
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
                
                let contextualMessage = buildContextualMessage(userText)
                
                let response = try await chat.sendMessage(contextualMessage)
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
    
    private func buildContextualMessage(_ userMessage: String) -> String {
        guard let user = UserStore.shared.currentUser else {
            return userMessage
        }
        
        let context = """
        [User Context - Do not repeat this back to the user, just use it to inform your response]
        - Cart items: \(String(describing: UserStore.shared.currentUser?.cart))
        - Favorites: \(String(describing: UserStore.shared.currentUser?.favorites))
        - Recent orders: \(String(describing: UserStore.shared.currentUser?.orders))
        
        User message: \(userMessage)
        """
        
        return context
    }
}

