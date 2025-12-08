// ContentView.swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapScreen()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }

            MeetsScreen()
                .tabItem {
                    Image(systemName: "person.3.sequence")
                    Text("Meets")
                }

            GroupsScreen()
                .tabItem {
                    Image(systemName: "person.2.circle")
                    Text("Groups")
                }

            ProfileScreen()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}
