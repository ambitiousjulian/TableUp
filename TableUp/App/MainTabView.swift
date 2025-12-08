//
//  MainTabView.swift
//  TableUp
//
//  Main tab bar navigation
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Map (Primary)
            HomeMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(0)

            // Meet Feed
            MeetFeedView()
                .tabItem {
                    Label("Meets", systemImage: "calendar")
                }
                .tag(1)

            // Search
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(2)

            // Groups
            GroupsView()
                .tabItem {
                    Label("Groups", systemImage: "person.3.fill")
                }
                .tag(3)

            // Profile
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .tag(4)
        }
        .accentColor(.primaryPurple)
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.backgroundCard)

            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
