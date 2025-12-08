//
//  ProfileView.swift
//  TableUp
//
//  User profile view
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()

                if viewModel.isLoading {
                    LoadingView()
                } else if let user = viewModel.user {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Profile header
                            VStack(spacing: 16) {
                                UserAvatar(photoURL: user.photoURL, size: 100)

                                Text(user.name)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.textPrimary)

                                if !user.bio.isEmpty {
                                    Text(user.bio)
                                        .bodyStyle()
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 32)
                                }

                                // XP Level
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.accentYellow)
                                    Text("\(user.xp) XP")
                                        .bodyStyle()
                                }
                            }
                            .padding(.top, 32)

                            // Interests
                            if !user.interests.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Interests")
                                        .titleStyle()
                                        .padding(.horizontal, 16)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(user.interests, id: \.self) { interest in
                                                CategoryPill(category: interest)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                    }
                                }
                            }

                            // Sign out button
                            SecondaryButton(title: "Sign Out") {
                                viewModel.signOut()
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 32)
                        }
                        .padding(.bottom, 32)
                    }
                } else {
                    EmptyStateView(
                        icon: "person.crop.circle.badge.exclamationmark",
                        title: "Profile not found",
                        message: "Unable to load your profile. Please try again."
                    )
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                Task {
                    await viewModel.loadProfile()
                }
            }
        }
    }
}
