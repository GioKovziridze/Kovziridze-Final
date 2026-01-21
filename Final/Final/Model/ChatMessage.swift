//
//  ChatMessage.swift
//  Final
//
//  Created by nika kovziridze on 20.01.26.
//

import Foundation

struct ChatMessage: Identifiable {
    enum Role {
        case user
        case assistant
    }

    let id = UUID()
    let role: Role
    let text: String
}
