//
//  ProfileViewModel.swift
//  TableUp
//
//  Profile ViewModel
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService.shared
    private let authService = AuthService.shared

    func loadProfile() async {
        guard let userId = authService.currentUser?.uid else {
            errorMessage = "Not authenticated"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            user = try await firestoreService.fetchUser(userId)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func signOut() {
        do {
            try authService.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
