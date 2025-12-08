//
//  GroupsView.swift
//  TableUp
//
//  Groups list view
//

import SwiftUI

struct GroupsView: View {
    @StateObject private var viewModel = GroupsViewModel()
    @State private var showCreateGroup = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()

                if viewModel.isLoading {
                    LoadingView()
                } else if viewModel.groups.isEmpty {
                    EmptyStateView(
                        icon: "person.3",
                        title: "No groups yet",
                        message: "Create or join a group to connect with like-minded people!",
                        actionTitle: "Create Group",
                        action: { showCreateGroup = true }
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.groups) { group in
                                GroupCard(group: group) {
                                    // Navigate to group detail
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Groups")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCreateGroup = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.primaryPurple)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadGroups()
                }
            }
        }
    }
}
