//
//  Notification.swift
//  TableUp
//
//  Push notification model
//

import Foundation
import FirebaseFirestore

struct AppNotification: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var type: NotificationType
    var meetId: String?
    var groupId: String?
    var fromUserId: String?
    var title: String
    var body: String
    var read: Bool
    var createdAt: Date

    enum NotificationType: String, Codable {
        case meetInvite = "meet_invite"
        case groupInvite = "group_invite"
        case meetReminder = "meet_reminder"
        case newAttendee = "new_attendee"
        case chatMessage = "chat_message"
        case nearbyMeet = "nearby_meet"
    }

    init(
        id: String? = nil,
        userId: String,
        type: NotificationType,
        meetId: String? = nil,
        groupId: String? = nil,
        fromUserId: String? = nil,
        title: String,
        body: String,
        read: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.type = type
        self.meetId = meetId
        self.groupId = groupId
        self.fromUserId = fromUserId
        self.title = title
        self.body = body
        self.read = read
        self.createdAt = createdAt
    }
}
