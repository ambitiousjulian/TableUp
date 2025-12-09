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
        } catch {
            errorMessage = error.localizedDescription
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
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
