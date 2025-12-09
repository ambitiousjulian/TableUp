//
//  HomeMapView.swift
//  TableUp
//
//  Main map view - PRIMARY SCREEN
//

import SwiftUI
import MapKit

struct HomeMapView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showCreateMeet = false

    var body: some View {
        NavigationView {
            ZStack {
            // Map
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.meets) { meet in
                MapAnnotation(coordinate: meet.coordinate) {
                    MeetMapAnnotation(meet: meet)
                }
            }
            .ignoresSafeArea()

            // Top filter chips
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.filters, id: \.self) { filter in
                            FilterChip(
                                title: filter,
                                isSelected: viewModel.selectedFilter == filter
                            ) {
                                viewModel.applyFilter(filter)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
                .background(Color.backgroundDark.opacity(0.9))

                Spacer()
            }

            // Create Meet FAB
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(action: { showCreateMeet = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            Text("Create Meet")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(Color.primaryPurple)
                        .cornerRadius(28)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            viewModel.refreshLocation()
            Task {
                await viewModel.loadNearbyMeets()
            }
        }
            .sheet(isPresented: $showCreateMeet) {
                CreateMeetView()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : .textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.primaryPurple : Color.backgroundCard)
                .cornerRadius(20)
        }
    }
}

struct MeetMapAnnotation: View {
    let meet: Meet

    var body: some View {
        if let meetId = meet.id {
            NavigationLink(destination: MeetDetailView(meetId: meetId)) {
                annotationContent
            }
        } else {
            annotationContent
        }
    }

    private var annotationContent: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color.forCategory(meet.primaryTag))
                    .frame(width: 40, height: 40)

                Image(systemName: "person.2.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }

            Text(meet.title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.backgroundCard)
                .cornerRadius(8)
        }
    }
}
