//
//  HomeViewModel.swift
//  TableUp
//
//  Home map ViewModel
//

import Foundation
import MapKit
import CoreLocation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var meets: [Meet] = []
    @Published var users: [User] = []
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.7617, longitude: -80.1918), // Miami
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var selectedFilter: String = "All"
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService.shared
    private let locationService = LocationService.shared
    private var notificationObservers: [NSObjectProtocol] = []

    let filters = ["All", "Tech", "Social", "Fitness", "Food", "Outdoors"]

    init() {
        setupNotifications()
    }

    deinit {
        notificationObservers.forEach { NotificationCenter.default.removeObserver($0) }
    }

    private func setupNotifications() {
        let observer1 = NotificationCenter.default.addObserver(
            forName: .meetCreated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                await self.loadNearbyMeets()
            }
        }

        let observer2 = NotificationCenter.default.addObserver(
            forName: .userJoinedMeet,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                await self.loadNearbyMeets()
            }
        }

        let observer3 = NotificationCenter.default.addObserver(
            forName: .userLeftMeet,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                await self.loadNearbyMeets()
            }
        }

        notificationObservers = [observer1, observer2, observer3]
    }


    func loadNearbyMeets() async {
        guard let location = locationService.currentLocation else {
            errorMessage = "Location not available"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let allMeets = try await firestoreService.fetchNearbyMeets(
                location: location,
                radiusKm: Constants.defaultMapRadius
            )

            // Filter by selected filter
            if selectedFilter == "All" {
                meets = allMeets
            } else {
                meets = allMeets.filter { $0.tags.contains(selectedFilter) }
            }

            // Update map region to user's location
            region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func applyFilter(_ filter: String) {
        selectedFilter = filter
        Task {
            await loadNearbyMeets()
        }
    }

    func refreshLocation() {
        locationService.startUpdatingLocation()
    }
}
