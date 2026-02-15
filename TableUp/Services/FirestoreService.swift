//
//  FirestoreService.swift
//  TableUp
//
//  Firestore database service
//

import Foundation
import FirebaseFirestore
import CoreLocation

class FirestoreService {
    static let shared = FirestoreService()

    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Users
    func createUser(_ user: User) async throws {
        guard let userId = user.id else {
            throw NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is required"])
        }
        try db.collection("users").document(userId).setData(from: user)
    }

    func fetchUser(_ userId: String) async throws -> User {
        let document = try await db.collection("users").document(userId).getDocument()
        return try document.data(as: User.self)
    }

    func updateUser(_ user: User) async throws {
        guard let userId = user.id else {
            throw NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is required"])
        }
        try db.collection("users").document(userId).setData(from: user, merge: true)
    }

    func checkUserExists(_ userId: String) async throws -> Bool {
        let document = try await db.collection("users").document(userId).getDocument()
        return document.exists
    }

    // MARK: - Meets
    func createMeet(_ meet: Meet) async throws -> String {
        let ref = try db.collection("meets").addDocument(from: meet)
        return ref.documentID
    }

    func fetchMeet(_ meetId: String) async throws -> Meet {
        let document = try await db.collection("meets").document(meetId).getDocument()
        return try document.data(as: Meet.self)
    }

    func fetchNearbyMeets(location: CLLocationCoordinate2D, radiusKm: Double = 10) async throws -> [Meet] {
        // Get all upcoming meets
        let snapshot = try await db.collection("meets")
            .whereField("startTime", isGreaterThan: Date())
            .limit(to: 100)
            .getDocuments()
        
        let allMeets = try snapshot.documents.compactMap { try? $0.data(as: Meet.self) }
        
        // Filter by distance client-side
        let userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        return allMeets.filter { meet in
            let meetLocation = CLLocation(latitude: meet.location.latitude, longitude: meet.location.longitude)
            let distance = userLocation.distance(from: meetLocation)
            return distance <= radiusKm * 1000 // Convert km to meters
        }
    }

    func listenToMeet(_ meetId: String, completion: @escaping (Result<Meet, Error>) -> Void) -> ListenerRegistration {
        return db.collection("meets").document(meetId).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])))
                return
            }
            do {
                let meet = try snapshot.data(as: Meet.self)
                completion(.success(meet))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func joinMeet(meetId: String, userId: String) async throws {
        let attendee = MeetAttendee(id: userId, joinedAt: Date(), status: .going)
        try db.collection("meets").document(meetId)
            .collection("attendees").document(userId)
            .setData(from: attendee)

        // Update attendee count
        try await db.collection("meets").document(meetId).updateData([
            "attendeeCount": FieldValue.increment(Int64(1))
        ])
    }

    func leaveMeet(meetId: String, userId: String) async throws {
        try await db.collection("meets").document(meetId)
            .collection("attendees").document(userId).delete()

        // Update attendee count
        try await db.collection("meets").document(meetId).updateData([
            "attendeeCount": FieldValue.increment(Int64(-1))
        ])
    }

    func checkIfAttending(meetId: String, userId: String) async throws -> Bool {
        let document = try await db.collection("meets")
            .document(meetId)
            .collection("attendees")
            .document(userId)
            .getDocument()
        return document.exists
    }

    func searchMeets(query: String) async throws -> [Meet] {
        guard !query.isEmpty else { return [] }

        let lowercasedQuery = query.lowercased()
        let snapshot = try await db.collection("meets")
            .whereField("startTime", isGreaterThan: Date())
            .limit(to: 50)
            .getDocuments()

        let allMeets = try snapshot.documents.compactMap { try? $0.data(as: Meet.self) }

        // Filter by title or tags containing query (client-side for now)
        return allMeets.filter { meet in
            meet.title.lowercased().contains(lowercasedQuery) ||
            meet.tags.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }

    // MARK: - Groups
    func createGroup(_ group: Group) async throws -> String {
        let ref = try db.collection("groups").addDocument(from: group)
        return ref.documentID
    }

    func fetchGroup(_ groupId: String) async throws -> Group {
        let document = try await db.collection("groups").document(groupId).getDocument()
        return try document.data(as: Group.self)
    }

    func fetchGroups(limit: Int = 20) async throws -> [Group] {
        let snapshot = try await db.collection("groups")
            .limit(to: limit)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Group.self) }
    }

    func joinGroup(groupId: String, userId: String) async throws {
        let member = GroupMember(id: userId, role: .member, joinedAt: Date())
        try db.collection("groups").document(groupId)
            .collection("members").document(userId)
            .setData(from: member)

        // Update member count
        try await db.collection("groups").document(groupId).updateData([
            "memberCount": FieldValue.increment(Int64(1))
        ])
    }

    // MARK: - Chat
    func sendMessage(to collection: String, documentId: String, message: ChatMessage) async throws {
        _ = try db.collection(collection).document(documentId)
            .collection("chat").addDocument(from: message)
    }

    func listenToChat(collection: String, documentId: String, completion: @escaping (Result<[ChatMessage], Error>) -> Void) -> ListenerRegistration {
        return db.collection(collection).document(documentId)
            .collection("chat")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let snapshot = snapshot else {
                    completion(.failure(NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])))
                    return
                }
                do {
                    let messages = try snapshot.documents.compactMap { try $0.data(as: ChatMessage.self) }
                    completion(.success(messages))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    func leaveGroup(groupId: String, userId: String) async throws {
        try await db.collection("groups").document(groupId)
            .collection("members").document(userId).delete()

        // Update member count
        try await db.collection("groups").document(groupId).updateData([
            "memberCount": FieldValue.increment(Int64(-1))
        ])
    }

    func searchGroups(query: String) async throws -> [Group] {
        guard !query.isEmpty else { return [] }

        let lowercasedQuery = query.lowercased()
        let snapshot = try await db.collection("groups")
            .limit(to: 50)
            .getDocuments()

        let allGroups = try snapshot.documents.compactMap { try? $0.data(as: Group.self) }

        // Filter by name or description containing query (client-side for now)
        return allGroups.filter { group in
            group.name.lowercased().contains(lowercasedQuery) ||
            group.description.lowercased().contains(lowercasedQuery) ||
            group.tags.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }
}
