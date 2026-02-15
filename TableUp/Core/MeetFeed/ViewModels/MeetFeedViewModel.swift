//
//  MeetFeedViewModel.swift
//  TableUp
//
//  Meet feed ViewModel
//

import Foundation

@MainActor
class MeetFeedViewModel: ObservableObject {
    @Published var meets: [Meet] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isRefreshing = false

    private let firestoreService = FirestoreService.shared
    private let locationService = LocationService.shared
    private var notificationObservers: [NSObjectProtocol] = []

    init() {
        setupNotifications()
    }

    deinit {
        notificationObservers.forEach { NotificationCenter.default.removeObserver($0) }
    }

    private func setupNotifications() {
        let observer1 = NotificationCenter.default.addObserver(
            forName: .userJoinedMeet,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                await self?.loadMeets(showLoading: false)
            }
        }

        let observer2 = NotificationCenter.default.addObserver(
            forName: .userLeftMeet,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                await self?.loadMeets(showLoading: false)
            }
        }

        let observer3 = NotificationCenter.default.addObserver(
            forName: .meetCreated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                await self?.loadMeets(showLoading: false)
            }
        }

        notificationObservers = [observer1, observer2, observer3]
    }

    var nowMeets: [Meet] {
        meets.filter { meet in
            let now = Date()
            return meet.startTime <= now && meet.endTime >= now
        }
    }

    var todayMeets: [Meet] {
        meets.filter { meet in
            Calendar.current.isDateInToday(meet.startTime)
        }
    }

    var thisWeekMeets: [Meet] {
        meets.filter { meet in
            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 7, to: startOfWeek)!
            return meet.startTime >= startOfWeek && meet.startTime < endOfWeek
        }
    }

    func loadMeets(showLoading: Bool = true) async {
        guard let location = locationService.currentLocation else {
            errorMessage = "Location not available"
            return
        }

        if showLoading {
            isLoading = true
        }
        errorMessage = nil

        do {
            meets = try await firestoreService.fetchNearbyMeets(
                location: location,
                radiusKm: Constants.defaultMapRadius
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
        isRefreshing = false
    }

    func refresh() async {
        isRefreshing = true
        await loadMeets(showLoading: false)
    }

    func joinMeet(_ meet: Meet) async {
        guard let userId = AuthService.shared.currentUser?.uid,
              let meetId = meet.id else { return }

        do {
            try await firestoreService.joinMeet(meetId: meetId, userId: userId)
            await loadMeets(showLoading: false) // Refresh
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
