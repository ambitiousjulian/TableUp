//
//  SearchView.swift
//  TableUp
//
//  Search view
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()

                VStack {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textSecondary)

                        TextField("Search meets, groups, people...", text: $viewModel.searchQuery)
                            .foregroundColor(.textPrimary)
                            .onChange(of: viewModel.searchQuery) { _, _ in
                                Task {
                                    await viewModel.performSearch()
                                }
                            }

                        if !viewModel.searchQuery.isEmpty {
                            Button(action: { viewModel.searchQuery = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.backgroundCard)
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                    // Results
                    if viewModel.searchQuery.isEmpty {
                        EmptyStateView(
                            icon: "magnifyingglass",
                            title: "Search",
                            message: "Find meets, groups, and people near you"
                        )
                    } else if viewModel.isLoading {
                        LoadingView(message: "Searching...")
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                // Meets results
                                if !viewModel.meets.isEmpty {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Meets")
                                            .titleStyle()
                                            .padding(.horizontal, 16)

                                        ForEach(viewModel.meets) { meet in
                                            MeetCard(meet: meet) {
                                                // Join action
                                            }
                                            .padding(.horizontal, 16)
                                        }
                                    }
                                }

                                // Groups results
                                if !viewModel.groups.isEmpty {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Groups")
                                            .titleStyle()
                                            .padding(.horizontal, 16)

                                        ForEach(viewModel.groups) { group in
                                            GroupCard(group: group) {
                                                // Navigate to group detail
                                            }
                                        }
                                    }
                                }

                                // No results
                                if viewModel.meets.isEmpty && viewModel.groups.isEmpty {
                                    EmptyStateView(
                                        icon: "magnifyingglass",
                                        title: "No results",
                                        message: "Try searching for something else"
                                    )
                                }
                            }
                            .padding(.vertical, 16)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
