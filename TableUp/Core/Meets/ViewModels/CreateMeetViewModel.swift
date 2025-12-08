//
//  CreateMeetViewModel.swift
//  TableUp
//
//  Create meet ViewModel
//

import Foundation
import CoreLocation
import FirebaseFirestore
import UIKit

@MainActor
class CreateMeetViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var locationName = ""
    @Published var selectedLocation: CLLocationCoordinate2D?
    @Published var startTime = Date().adding(hours: 1)
    @Published var endTime = Date().adding(hours: 3)
    @Published var capacity = 10
    @Published var selectedTags: [String] = []
    @Published var selectedImage: UIImage?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService.shared
    private let storageService = StorageService.shared
    private let authService = AuthService.shared
    private let locationService = LocationService.shared

    var canCreate: Bool {
        !title.isEmpty && !locationName.isEmpty && selectedLocation != nil && !selectedTags.isEmpty
    }

    init() {
        // Set default location to user's current location
        selectedLocation = locationService.currentLocation
    }

    func createMeet() async -> Bool {
        guard let userId = authService.currentUser?.uid,
              let location = selectedLocation else {
            errorMessage = "Authentication or location error"
            return false
        }

        guard canCreate else {
            errorMessage = "Please fill in all required fields"
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            let geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
            let geohash = GeoHashHelper.encode(latitude: location.latitude, longitude: location.longitude)

            var photoURL: String?
            if let image = selectedImage {
                // Create temporary meet ID for photo upload
                let tempMeetId = UUID().uuidString
                photoURL = try await storageService.uploadMeetPhoto(meetId: tempMeetId, image: image)
            }

            let meet = Meet(
                title: title,
                description: description,
                hostId: userId,
                location: geoPoint,
                locationName: locationName,
                startTime: startTime,
                endTime: endTime,
                capacity: capacity,
                tags: selectedTags,
                photoURL: photoURL,
                geohash: geohash
            )

            _ = try await firestoreService.createMeet(meet)

            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
