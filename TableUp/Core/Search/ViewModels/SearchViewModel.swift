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
        errorMessage = nil

        do {
            // Use improved search methods with client-side filtering
            async let meetsResult = firestoreService.searchMeets(query: searchQuery)
            async let groupsResult = firestoreService.searchGroups(query: searchQuery)

            meets = try await meetsResult
            groups = try await groupsResult
        } catch {
            errorMessage = error.localizedDescription
            meets = []
            groups = []
        }

        isLoading = false
    }
}
