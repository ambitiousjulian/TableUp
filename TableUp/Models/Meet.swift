//
//  Meet.swift
//  TableUp
//
//  Core meet/event model
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Meet: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var hostId: String
    var location: GeoPoint
    var locationName: String
    var startTime: Date
    var endTime: Date
    var capacity: Int
    var tags: [String]
    var groupId: String?
    var venueId: String?
    var photoURL: String?
    var createdAt: Date
    var attendeeCount: Int
    var geohash: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: location.latitude,
            longitude: location.longitude
        )
    }

    var primaryTag: String {
        tags.first ?? "General"
    }

    init(
        id: String? = nil,
        title: String,
        description: String,
        hostId: String,
        location: GeoPoint,
        locationName: String,
        startTime: Date,
        endTime: Date,
        capacity: Int,
        tags: [String] = [],
        groupId: String? = nil,
        venueId: String? = nil,
        photoURL: String? = nil,
        createdAt: Date = Date(),
        attendeeCount: Int = 0,
        geohash: String = ""
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.hostId = hostId
        self.location = location
        self.locationName = locationName
        self.startTime = startTime
        self.endTime = endTime
        self.capacity = capacity
        self.tags = tags
        self.groupId = groupId
        self.venueId = venueId
        self.photoURL = photoURL
        self.createdAt = createdAt
        self.attendeeCount = attendeeCount
        self.geohash = geohash
    }
}

struct MeetAttendee: Identifiable, Codable {
    var id: String // userId
    var joinedAt: Date
    var status: AttendeeStatus

    enum AttendeeStatus: String, Codable {
        case going
        case interested
        case cancelled
    }
}
