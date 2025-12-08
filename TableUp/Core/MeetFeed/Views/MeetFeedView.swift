//
//  MeetFeedView.swift
//  TableUp
//
//  Meet feed view
//

import SwiftUI

struct MeetFeedView: View {
    @StateObject private var viewModel = MeetFeedViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()

                if viewModel.isLoading {
                    LoadingView()
                } else if viewModel.meets.isEmpty {
                    EmptyStateView(
                        icon: "calendar.badge.exclamationmark",
                        title: "No meets nearby",
                        message: "Be the first to create a meet in your area!",
                        actionTitle: "Create Meet",
                        action: {
                            // Navigate to create meet
                        }
                    )
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Now section
                            if !viewModel.nowMeets.isEmpty {
                                MeetSection(
                                    title: "Happening Now",
                                    meets: viewModel.nowMeets,
                                    onJoin: { meet in
                                        Task {
                                            await viewModel.joinMeet(meet)
                                        }
                                    }
                                )
                            }

                            // Today section
                            if !viewModel.todayMeets.isEmpty {
                                MeetSection(
                                    title: "Today",
                                    meets: viewModel.todayMeets,
                                    onJoin: { meet in
                                        Task {
                                            await viewModel.joinMeet(meet)
                                        }
                                    }
                                )
                            }

                            // This week section
                            if !viewModel.thisWeekMeets.isEmpty {
                                MeetSection(
                                    title: "This Week",
                                    meets: viewModel.thisWeekMeets,
                                    onJoin: { meet in
                                        Task {
                                            await viewModel.joinMeet(meet)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Meets")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                Task {
                    await viewModel.loadMeets()
                }
            }
        }
    }
}

struct MeetSection: View {
    let title: String
    let meets: [Meet]
    let onJoin: (Meet) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 16)

            ForEach(meets) { meet in
                MeetCard(meet: meet) {
                    onJoin(meet)
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
