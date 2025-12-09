//
//  GroupDetailView.swift
//  TableUp
//
//  Group detail view
//

import SwiftUI

struct GroupDetailView: View {
    let groupId: String
    @StateObject private var viewModel = GroupDetailViewModel()
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
            } else if let group = viewModel.group {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Group header
                        VStack(alignment: .leading, spacing: 12) {
                            Text(group.name)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Text(group.description)
                                .bodyStyle()
                            
                            HStack(spacing: 16) {
                                Label("\(group.memberCount) members", systemImage: "person.2")
                                    .captionStyle()
                            }
                        }
                        .padding(.horizontal)
                        
                        // Join/Leave button
                        PrimaryButton(
                            title: viewModel.isMember ? "Leave Group" : "Join Group",
                            action: {
                                Task {
                                    if viewModel.isMember {
                                        await viewModel.leaveGroup()
                                    } else {
                                        await viewModel.joinGroup()
                                    }
                                }
                            },
                            isLoading: viewModel.isLoading
                        )
                        .padding(.horizontal)
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.accentRed)
                                .captionStyle()
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadGroup(groupId: groupId)
        }
    }
}
