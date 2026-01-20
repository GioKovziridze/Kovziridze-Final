//
//  SupportChatView.swift
//  Final
//
//  Created by nika kovziridze on 20.01.26.
//

import SwiftUI

struct SupportChatView: View {

    @StateObject private var viewModel = SupportChatViewModel()

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.messages) { msg in
                        HStack {
                            if msg.role == "user" { Spacer() }

                            Text(msg.content)
                                .padding()
                                .background(
                                    msg.role == "user" ? Color.blue : Color.gray.opacity(0.2)
                                )
                                .foregroundColor(msg.role == "user" ? .white : .black)
                                .cornerRadius(14)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .leading)

                            if msg.role == "assistant" { Spacer() }
                        }
                    }
                }
            }

            HStack {
                TextField("Ask support...", text: $viewModel.input)
                    .textFieldStyle(.roundedBorder)
                    .frame(minHeight: 30)

                Button("Send") {
                    viewModel.send()
                }
                .disabled(viewModel.input.isEmpty || viewModel.isLoading)
            }
            .padding()
        }
        .navigationTitle("AI Support")
    }
}
