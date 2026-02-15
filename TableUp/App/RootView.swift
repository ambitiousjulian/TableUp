//
//  RootView.swift
//  TableUp
//
//  Root view that handles authentication state
//

import SwiftUI

struct RootView: View {
    @StateObject private var authService = AuthService.shared
    @StateObject private var locationService = LocationService.shared
    @State private var isProfileSetupComplete = false
    @State private var isCheckingProfile = true

    var body: some View {
        ZStack {
            if isCheckingProfile {
                LoadingView(message: "Loading...")
            } else if authService.isAuthenticated {
                if isProfileSetupComplete {
                    MainTabView()
                } else {
                    ProfileSetupView(isCompleted: $isProfileSetupComplete)
                }
            } else {
                AuthenticationFlowView()
            }
        }
        .onAppear {
            locationService.requestPermission()
            Task {
                await NotificationService.shared.requestPermission()
            }
        }
        .onChange(of: authService.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                Task {
                    await checkProfile()
                }
            } else {
                isProfileSetupComplete = false
                isCheckingProfile = false
            }
        }
        .task {
            await checkProfile()
        }
    }

    private func checkProfile() async {
        guard let userId = authService.currentUser?.uid else {
            isCheckingProfile = false
            isProfileSetupComplete = false
            return
        }

        do {
            // Use checkUserExists instead of fetching entire user
            isProfileSetupComplete = try await FirestoreService.shared.checkUserExists(userId)
        } catch {
            isProfileSetupComplete = false
        }

        isCheckingProfile = false
    }
}

struct AuthenticationFlowView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        ZStack {
            switch viewModel.authState {
            case .signedOut:
                SignInView()
                    .environmentObject(viewModel)
            case .verifyingPhone:
                PhoneAuthView(viewModel: viewModel)
            case .settingUpProfile:
                ProfileSetupView(isCompleted: .constant(false))
            case .signedIn:
                MainTabView()
            }
        }
    }
}
