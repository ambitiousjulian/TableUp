//
//  SearchViewModel.swift
//  TableUp
//
//  Search ViewModel
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var meets: [Meet] = []
    @Published var groups: [Group] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService.shared

    func performSearch() async {
        guard !searchQuery.isEmpty else {
            meets = []
            groups = []
            return
        }

        isLoading = true
        errorMessage = nil

        // TODO: Implement actual search functionality
        // For now, just clear results
        meets = []
        groups = []

        isLoading = false
    }
}
