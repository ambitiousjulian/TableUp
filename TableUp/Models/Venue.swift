//
//  Venue.swift
//  TableUp
//
//  Venue/location model
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Venue: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var address: String
    var location: GeoPoint
    var type: VenueType
    var photoURL: String?
    var geohash: String
    var createdAt: Date

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: location.latitude,
            longitude: location.longitude
        )
    }

    enum VenueType: String, Codable {
        case cafe
        case bar
        case restaurant
        case park
        case other
    }
}

struct VenueTable: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var capacity: Int
    var photoURL: String?
}
