//
//  GroupDetailViewModel.swift
//  TableUp
//
//  Group detail ViewModel
//

import Foundation
import FirebaseFirestore

@MainActor
class GroupDetailViewModel: ObservableObject {
    @Published var group: Group?
    @Published var isMember = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var toast: ToastMessage?

    private let firestoreService = FirestoreService.shared
    private let authService = AuthService.shared
    private let db = Firestore.firestore()
    
    func loadGroup(groupId: String) {
        isLoading = true
        Task {
            do {
                group = try await firestoreService.fetchGroup(groupId)
                await checkMembership(groupId: groupId)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    private func checkMembership(groupId: String) async {
        guard let userId = authService.currentUser?.uid else { return }
        
        do {
            let snapshot = try await db.collection("groups")
                .document(groupId)
                .collection("members")
                .document(userId)
                .getDocument()
            
            isMember = snapshot.exists
        } catch {
            isMember = false
        }
    }
    
    func joinGroup() async {
        guard let userId = authService.currentUser?.uid,
              let groupId = group?.id else { return }

        isLoading = true
        do {
            try await firestoreService.joinGroup(groupId: groupId, userId: userId)
            isMember = true

            // Update member count optimistically
            group?.memberCount += 1

            // Notify other views
            NotificationCenter.default.post(
                name: .userJoinedGroup,
                object: nil,
                userInfo: [NotificationKeys.groupId: groupId]
            )

            // Show success toast
            toast = ToastMessage(message: "Successfully joined group!", style: .success)
        } catch {
            errorMessage = error.localizedDescription
            toast = ToastMessage(message: "Failed to join group", style: .error)
        }
        isLoading = false
    }
    
    func leaveGroup() async {
        guard let userId = authService.currentUser?.uid,
              let groupId = group?.id else { return }

        isLoading = true
        do {
            try await firestoreService.leaveGroup(groupId: groupId, userId: userId)
            isMember = false

            // Update member count optimistically
            group?.memberCount = max(0, (group?.memberCount ?? 0) - 1)

            // Notify other views
            NotificationCenter.default.post(
                name: .userLeftGroup,
                object: nil,
                userInfo: [NotificationKeys.groupId: groupId]
            )

            // Show success toast
            toast = ToastMessage(message: "Left group", style: .info)
        } catch {
            errorMessage = error.localizedDescription
            toast = ToastMessage(message: "Failed to leave group", style: .error)
        }
        isLoading = false
    }
}
