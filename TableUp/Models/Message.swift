//
//  Message.swift
//  TableUp
//
//  Chat message models
//

import Foundation
import FirebaseFirestore

struct ChatMessage: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var text: String
    var photoURL: String?
    var createdAt: Date

    init(
        id: String? = nil,
        userId: String,
        text: String,
        photoURL: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.text = text
        self.photoURL = photoURL
        self.createdAt = createdAt
    }
}

struct Conversation: Identifiable, Codable {
    @DocumentID var id: String?
    var participants: [String]
    var lastMessage: String
    var lastMessageAt: Date
    var unreadCount: [String: Int]

    init(
        id: String? = nil,
        participants: [String],
        lastMessage: String = "",
        lastMessageAt: Date = Date(),
        unreadCount: [String: Int] = [:]
    ) {
        self.id = id
        self.participants = participants
        self.lastMessage = lastMessage
        self.lastMessageAt = lastMessageAt
        self.unreadCount = unreadCount
    }
}
