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
                ProgressView()
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
                await checkProfile()
            }
        }
    }
    
    private func checkProfile() async {
        guard let userId = authService.currentUser?.uid else {
            isCheckingProfile = false
            return
        }
        
        do {
            let user = try await FirestoreService.shared.fetchUser(userId)
            isProfileSetupComplete = user != nil
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
