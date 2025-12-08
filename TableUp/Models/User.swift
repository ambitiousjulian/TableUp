//
//  User.swift
//  TableUp
//
//  Core user model
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var bio: String
    var photoURL: String?
    var interests: [String]
    var instagramURL: String?
    var linkedinURL: String?
    var xp: Int
    var createdAt: Date
    var fcmTokens: [String]

    init(
        id: String? = nil,
        name: String,
        bio: String = "",
        photoURL: String? = nil,
        interests: [String] = [],
        instagramURL: String? = nil,
        linkedinURL: String? = nil,
        xp: Int = 0,
        createdAt: Date = Date(),
        fcmTokens: [String] = []
    ) {
        self.id = id
        self.name = name
        self.bio = bio
        self.photoURL = photoURL
        self.interests = interests
        self.instagramURL = instagramURL
        self.linkedinURL = linkedinURL
        self.xp = xp
        self.createdAt = createdAt
        self.fcmTokens = fcmTokens
    }
}

struct UserStatus: Codable {
    var isLive: Bool
    var lastLocation: GeoPoint?
    var lastActive: Date

    var coordinate: CLLocationCoordinate2D? {
        guard let lastLocation = lastLocation else { return nil }
        return CLLocationCoordinate2D(
            latitude: lastLocation.latitude,
            longitude: lastLocation.longitude
        )
    }
}
