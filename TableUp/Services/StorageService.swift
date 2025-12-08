//
//  StorageService.swift
//  TableUp
//
//  Firebase Storage service for images
//

import Foundation
import FirebaseStorage
import UIKit

class StorageService {
    static let shared = StorageService()

    private let storage = Storage.storage()

    private init() {}

    // MARK: - Upload Images
    func uploadUserPhoto(userId: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw NSError(domain: "StorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }

        let path = "users/\(userId)/profile.jpg"
        let ref = storage.reference().child(path)

        _ = try await ref.putDataAsync(imageData)
        let downloadURL = try await ref.downloadURL()
        return downloadURL.absoluteString
    }

    func uploadMeetPhoto(meetId: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw NSError(domain: "StorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }

        let path = "meets/\(meetId)/photo.jpg"
        let ref = storage.reference().child(path)

        _ = try await ref.putDataAsync(imageData)
        let downloadURL = try await ref.downloadURL()
        return downloadURL.absoluteString
    }

    func uploadGroupPhoto(groupId: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw NSError(domain: "StorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }

        let path = "groups/\(groupId)/photo.jpg"
        let ref = storage.reference().child(path)

        _ = try await ref.putDataAsync(imageData)
        let downloadURL = try await ref.downloadURL()
        return downloadURL.absoluteString
    }

    // MARK: - Delete Images
    func deleteImage(at path: String) async throws {
        let ref = storage.reference().child(path)
        try await ref.delete()
    }
}
