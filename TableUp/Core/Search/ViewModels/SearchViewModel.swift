//
//  SearchViewModel.swift
//  TableUp
//
//  Search ViewModel
//

import Foundation
import FirebaseFirestore

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var meets: [Meet] = []
    @Published var groups: [Group] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService.shared
    private let db = Firestore.firestore()  

    func performSearch() async {
        guard !searchQuery.isEmpty else {
            meets = []
            groups = []
            return
        }
        
        isLoading = true
        
        do {
            // Search meets
            let meetsSnapshot = try await db.collection("meets")
                .whereField("title", isGreaterThanOrEqualTo: searchQuery)
                .whereField("title", isLessThan: searchQuery + "\u{f8ff}")
                .limit(to: 20)
                .getDocuments()
            
            meets = try meetsSnapshot.documents.compactMap { try $0.data(as: Meet.self) }
            
            // Search groups
            let groupsSnapshot = try await db.collection("groups")
                .whereField("name", isGreaterThanOrEqualTo: searchQuery)
                .whereField("name", isLessThan: searchQuery + "\u{f8ff}")
                .limit(to: 20)
                .getDocuments()
            
            groups = try groupsSnapshot.documents.compactMap { try $0.data(as: Group.self) }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
