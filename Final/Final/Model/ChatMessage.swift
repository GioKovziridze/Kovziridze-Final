//
//  ChatMessage.swift
//  Final
//
//  Created by nika kovziridze on 20.01.26.
//
import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: String
    let content: String
}
