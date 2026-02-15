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
    @Published var isRefreshing = false

    private let firestoreService = FirestoreService.shared
    private var notificationObservers: [NSObjectProtocol] = []

    init() {
        setupNotifications()
    }

    deinit {
        notificationObservers.forEach { NotificationCenter.default.removeObserver($0) }
    }

    private func setupNotifications() {
        let observer1 = NotificationCenter.default.addObserver(
            forName: .userJoinedGroup,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                await self.loadGroups(showLoading: false)
            }
        }

        let observer2 = NotificationCenter.default.addObserver(
            forName: .userLeftGroup,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                await self.loadGroups(showLoading: false)
            }
        }

        let observer3 = NotificationCenter.default.addObserver(
            forName: .groupCreated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                await self.loadGroups(showLoading: false)
            }
        }

        notificationObservers = [observer1, observer2, observer3]
    }


    func loadGroups(showLoading: Bool = true) async {
        if showLoading {
            isLoading = true
        }
        errorMessage = nil

        do {
            groups = try await firestoreService.fetchGroups(limit: 50)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
        isRefreshing = false
    }

    func refresh() async {
        isRefreshing = true
        await loadGroups(showLoading: false)
    }

    func joinGroup(_ group: Group) async {
        guard let userId = AuthService.shared.currentUser?.uid,
              let groupId = group.id else { return }

        do {
            try await firestoreService.joinGroup(groupId: groupId, userId: userId)
            await loadGroups(showLoading: false) // Refresh
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
