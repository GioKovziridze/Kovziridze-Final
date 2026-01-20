//
//  SupportChatViewModel.swift
//  Final
//
//  Created by nika kovziridze on 20.01.26.
//
import Foundation

@MainActor
final class SupportChatViewModel: ObservableObject {

    @Published var messages: [ChatMessage] = []
    @Published var input = ""
    @Published var isLoading = false

    private let apiKey = "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"
    private let model = "google/flan-t5-small"

    func send() {
        let userMessage = ChatMessage(
            role: "user",
            content: input
        )

        messages.append(userMessage)
        input = ""
        isLoading = true

        Task {
            do {
                let reply = try await generateResponse(for: userMessage.content)
                
                messages.append(
                    ChatMessage(role: "assistant", content: reply)
                )
            } catch {
                messages.append(
                    ChatMessage(
                        role: "assistant",
                        content: " \(error.localizedDescription)"
                    )
                )
            }
            isLoading = false
        }
    }
  

    private func generateResponse(for message: String) async throws -> String {

        let apiKey = "AIzaSyDVYRuhplG2DAyjsNCUtD6zcmljs0hhwpI"

        guard let url = URL(
            string: "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=\(apiKey)"
        ) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "contents": [
                [
                    "role": "user",
                    "parts": [
                        ["text": message]
                    ]
                ]
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            return " HTTP \(http.statusCode): \(String(data: data, encoding: .utf8) ?? "")"
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        if let candidates = json?["candidates"] as? [[String: Any]],
           let content = candidates.first?["content"] as? [String: Any],
           let parts = content["parts"] as? [[String: Any]],
           let text = parts.first?["text"] as? String {
            return text
        }

        return "Unexpected response: \(String(data: data, encoding: .utf8) ?? "")"
    }




}
