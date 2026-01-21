//
//  SupportChatView.swift
//  Final
//
//  Created by nika kovziridze on 20.01.26.
//

import SwiftUI

struct SupportChatView: View {
    
    @StateObject private var vm = SupportChatViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(vm.messages) { msg in
                        HStack {
                            if msg.role == .user { Spacer() }
                            
                            Text(msg.text)
                                .padding()
                                .background(
                                    msg.role == .user
                                    ? Color.blue
                                    : Color.gray.opacity(0.2)
                                )
                                .foregroundColor(
                                    msg.role == .user ? .white : .black
                                )
                                .cornerRadius(14)
                                .frame(maxWidth: 280, alignment: .leading)
                            
                            if msg.role == .assistant { Spacer() }
                        }
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Ask support…", text: $vm.input)
                    .textFieldStyle(.roundedBorder)
                
                Button("Send") {
                    vm.send()
                }
                .disabled(vm.input.isEmpty || vm.isLoading)
            }
            .padding()
        }
        .navigationTitle("AI Support")
    }
}
