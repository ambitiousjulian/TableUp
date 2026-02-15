//
//  CreateGroupViewModel.swift
//  TableUp
//
//  Create group ViewModel
//

import Foundation
import UIKit

@MainActor
class CreateGroupViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var selectedTags: [String] = []
    @Published var selectedImage: UIImage?
    @Published var isPrivate = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService.shared
    private let storageService = StorageService.shared
    private let authService = AuthService.shared

    var canCreate: Bool {
        !name.isEmpty && !description.isEmpty && !selectedTags.isEmpty
    }

    func createGroup() async -> Bool {
        guard let userId = authService.currentUser?.uid else {
            errorMessage = "Authentication error"
            return false
        }

        guard canCreate else {
            errorMessage = "Please fill in all required fields"
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            var photoURL: String?
            if let image = selectedImage {
                // Create temporary group ID for photo upload
                let tempGroupId = UUID().uuidString
                photoURL = try await storageService.uploadGroupPhoto(groupId: tempGroupId, image: image)
            }

            let group = Group(
                name: name,
                description: description,
                photoURL: photoURL,
                tags: selectedTags,
                ownerId: userId,
                isPrivate: isPrivate
            )

            let groupId = try await firestoreService.createGroup(group)

            // Auto-join the creator as owner
            try await firestoreService.joinGroup(groupId: groupId, userId: userId)

            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
