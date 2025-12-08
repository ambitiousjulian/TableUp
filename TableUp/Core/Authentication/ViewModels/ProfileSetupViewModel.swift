//
//  ProfileSetupViewModel.swift
//  TableUp
//
//  Profile setup ViewModel
//

import Foundation
import UIKit

@MainActor
class ProfileSetupViewModel: ObservableObject {
    @Published var name = ""
    @Published var bio = ""
    @Published var selectedImage: UIImage?
    @Published var selectedInterests: [String] = []
    @Published var instagramURL = ""
    @Published var linkedinURL = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService.shared
    private let storageService = StorageService.shared
    private let authService = AuthService.shared

    var canContinue: Bool {
        !name.isEmpty && selectedInterests.count >= 3
    }

    func createProfile() async -> Bool {
        guard let userId = authService.currentUser?.uid else {
            errorMessage = "User not authenticated"
            return false
        }

        guard canContinue else {
            errorMessage = "Please enter your name and select at least 3 interests"
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            // Upload photo if selected
            var photoURL: String?
            if let image = selectedImage {
                photoURL = try await storageService.uploadUserPhoto(userId: userId, image: image)
            }

            // Create user document
            let user = User(
                id: userId,
                name: name,
                bio: bio,
                photoURL: photoURL,
                interests: selectedInterests,
                instagramURL: instagramURL.isEmpty ? nil : instagramURL,
                linkedinURL: linkedinURL.isEmpty ? nil : linkedinURL
            )

            try await firestoreService.createUser(user)

            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
