//
//  AppNotifications.swift
//  TableUp
//
//  Notification names for cross-view updates
//

import Foundation

extension Notification.Name {
    static let meetUpdated = Notification.Name("meetUpdated")
    static let groupUpdated = Notification.Name("groupUpdated")
    static let userJoinedMeet = Notification.Name("userJoinedMeet")
    static let userLeftMeet = Notification.Name("userLeftMeet")
    static let userJoinedGroup = Notification.Name("userJoinedGroup")
    static let userLeftGroup = Notification.Name("userLeftGroup")
    static let meetCreated = Notification.Name("meetCreated")
    static let groupCreated = Notification.Name("groupCreated")
}

struct NotificationKeys {
    static let meetId = "meetId"
    static let groupId = "groupId"
}
