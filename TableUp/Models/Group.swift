//
//  Group.swift
//  TableUp
//
//  Community group model
//

import Foundation
import FirebaseFirestore

struct Group: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var photoURL: String?
    var tags: [String]
    var ownerId: String
    var memberCount: Int
    var isPrivate: Bool
    var createdAt: Date

    init(
        id: String? = nil,
        name: String,
        description: String,
        photoURL: String? = nil,
        tags: [String] = [],
        ownerId: String,
        memberCount: Int = 1,
        isPrivate: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.photoURL = photoURL
        self.tags = tags
        self.ownerId = ownerId
        self.memberCount = memberCount
        self.isPrivate = isPrivate
        self.createdAt = createdAt
    }
}

struct GroupMember: Identifiable, Codable {
    var id: String // userId
    var role: MemberRole
    var joinedAt: Date

    enum MemberRole: String, Codable {
        case owner
        case admin
        case member
    }
}
