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

    var body: some View {
        Group {
            if authService.isAuthenticated {
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
            // Request location permission
            locationService.requestPermission()

            // Request notification permission
            Task {
                await NotificationService.shared.requestPermission()
            }
        }
    }
}

struct AuthenticationFlowView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        Group {
            switch viewModel.authState {
            case .signedOut:
                SignInView()
            case .verifyingPhone:
                PhoneAuthView(viewModel: viewModel)
            case .settingUpProfile:
                ProfileSetupView(isCompleted: .constant(false))
            case .signedIn:
                MainTabView()
            }
        }
        .environmentObject(viewModel)
    }
}
