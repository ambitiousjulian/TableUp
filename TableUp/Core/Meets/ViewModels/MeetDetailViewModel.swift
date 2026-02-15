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
    @Published var toast: ToastMessage?

    private let firestoreService = FirestoreService.shared
    private let authService = AuthService.shared
    private let db = Firestore.firestore()
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

        do {
            let snapshot = try await db.collection("meets")
                .document(meetId)
                .collection("attendees")
                .document(userId)
                .getDocument()

            isAttending = snapshot.exists
        } catch {
            isAttending = false
        }
    }

    func joinMeet() async {
        guard let userId = authService.currentUser?.uid,
              let meetId = meet?.id else { return }

        do {
            try await firestoreService.joinMeet(meetId: meetId, userId: userId)
            isAttending = true

            // Update attendee count optimistically
            meet?.attendeeCount += 1

            // Notify other views
            NotificationCenter.default.post(
                name: .userJoinedMeet,
                object: nil,
                userInfo: [NotificationKeys.meetId: meetId]
            )

            // Show success toast
            toast = ToastMessage(message: "You're going to this meet!", style: .success)
        } catch {
            errorMessage = error.localizedDescription
            toast = ToastMessage(message: "Failed to join meet", style: .error)
        }
    }

    func leaveMeet() async {
        guard let userId = authService.currentUser?.uid,
              let meetId = meet?.id else { return }

        do {
            try await firestoreService.leaveMeet(meetId: meetId, userId: userId)
            isAttending = false

            // Update attendee count optimistically
            meet?.attendeeCount = max(0, (meet?.attendeeCount ?? 0) - 1)

            // Notify other views
            NotificationCenter.default.post(
                name: .userLeftMeet,
                object: nil,
                userInfo: [NotificationKeys.meetId: meetId]
            )

            // Show success toast
            toast = ToastMessage(message: "You left this meet", style: .info)
        } catch {
            errorMessage = error.localizedDescription
            toast = ToastMessage(message: "Failed to leave meet", style: .error)
        }
    }

    deinit {
        listener?.remove()
    }
}
