//
//  MeetDetailViewModel.swift
//  TableUp
//
//  Meet detail ViewModel
//

import Foundation
import FirebaseFirestore

@MainActor
class MeetDetailViewModel: ObservableObject {
    @Published var meet: Meet?
    @Published var attendees: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAttending = false

    private let firestoreService = FirestoreService.shared
    private let authService = AuthService.shared
    private var listener: ListenerRegistration?

    func loadMeet(meetId: String) {
        isLoading = true
        listener = firestoreService.listenToMeet(meetId) { [weak self] result in
            Task { @MainActor in
                self?.isLoading = false
                switch result {
                case .success(let meet):
                    self?.meet = meet
                    await self?.checkIfAttending(meetId: meetId)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func checkIfAttending(meetId: String) async {
        guard let userId = authService.currentUser?.uid else { return }
        // TODO: Check if user is attending
        // For now, just set to false
        isAttending = false
    }

    func joinMeet() async {
        guard let userId = authService.currentUser?.uid,
              let meetId = meet?.id else { return }

        do {
            try await firestoreService.joinMeet(meetId: meetId, userId: userId)
            isAttending = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func leaveMeet() async {
        guard let userId = authService.currentUser?.uid,
              let meetId = meet?.id else { return }

        do {
            try await firestoreService.leaveMeet(meetId: meetId, userId: userId)
            isAttending = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    deinit {
        listener?.remove()
    }
}
