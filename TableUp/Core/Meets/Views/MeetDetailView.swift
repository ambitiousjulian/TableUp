//
//  MeetDetailView.swift
//  TableUp
//
//  Meet detail view
//

import SwiftUI
import MapKit

struct MeetDetailView: View {
    let meetId: String
    @StateObject private var viewModel = MeetDetailViewModel()

    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()

            if viewModel.isLoading {
                LoadingView()
            } else if let meet = viewModel.meet {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header image or map
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: meet.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )), annotationItems: [meet]) { meet in
                            MapMarker(coordinate: meet.coordinate, tint: .primaryPurple)
                        }
                        .frame(height: 200)
                        .cornerRadius(16)
                        .padding(.horizontal, 16)

                        VStack(alignment: .leading, spacing: 16) {
                            // Title
                            Text(meet.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.textPrimary)

                            // Time
                            HStack(spacing: 8) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.accentBlue)
                                VStack(alignment: .leading) {
                                    Text(meet.startTime.formatted(style: .dateTime))
                                        .bodyStyle()
                                    Text("to \(meet.endTime.formatted(style: .time))")
                                        .captionStyle()
                                }
                            }

                            // Location
                            HStack(spacing: 8) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.accentBlue)
                                Text(meet.locationName)
                                    .bodyStyle()
                            }

                            // Capacity
                            HStack(spacing: 8) {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(.accentBlue)
                                Text("\(meet.attendeeCount) / \(meet.capacity) attending")
                                    .bodyStyle()
                            }

                            // Tags
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(meet.tags, id: \.self) { tag in
                                        CategoryPill(category: tag)
                                    }
                                }
                            }

                            // Description
                            if !meet.description.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("About")
                                        .titleStyle()

                                    Text(meet.description)
                                        .bodyStyle()
                                }
                                .padding(.top, 8)
                            }

                            // Join/Leave button
                            if viewModel.isAttending {
                                SecondaryButton(title: "Leave Meet") {
                                    Task {
                                        await viewModel.leaveMeet()
                                    }
                                }
                            } else {
                                PrimaryButton(title: "Join Meet") {
                                    Task {
                                        await viewModel.joinMeet()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }
            } else {
                EmptyStateView(
                    icon: "exclamationmark.triangle",
                    title: "Meet not found",
                    message: "This meet may have been deleted or doesn't exist."
                )
            }
        }
        .navigationTitle("Meet Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadMeet(meetId: meetId)
        }
    }
}
