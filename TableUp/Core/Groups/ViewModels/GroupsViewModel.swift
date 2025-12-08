//
//  GroupsViewModel.swift
//  TableUp
//
//  Groups ViewModel
//

import Foundation

@MainActor
class GroupsViewModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService.shared

    func loadGroups() async {
        isLoading = true
        errorMessage = nil

        do {
            groups = try await firestoreService.fetchGroups(limit: 50)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func joinGroup(_ group: Group) async {
        guard let userId = AuthService.shared.currentUser?.uid,
              let groupId = group.id else { return }

        do {
            try await firestoreService.joinGroup(groupId: groupId, userId: userId)
            await loadGroups() // Refresh
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
