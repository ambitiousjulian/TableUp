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

    private let firestoreService = FirestoreService.shared
    private let locationService = LocationService.shared

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

    func loadMeets() async {
        guard let location = locationService.currentLocation else {
            errorMessage = "Location not available"
            return
        }

        isLoading = true
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
    }

    func joinMeet(_ meet: Meet) async {
        guard let userId = AuthService.shared.currentUser?.uid,
              let meetId = meet.id else { return }

        do {
            try await firestoreService.joinMeet(meetId: meetId, userId: userId)
            await loadMeets() // Refresh
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
