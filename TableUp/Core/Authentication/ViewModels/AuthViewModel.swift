//
//  AuthViewModel.swift
//  TableUp
//
//  Authentication ViewModel
//

import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var verificationCode = ""
    @Published var verificationID: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var authState: AuthState = .signedOut

    private let authService = AuthService.shared
    private let firestoreService = FirestoreService.shared

    enum AuthState {
        case signedOut
        case verifyingPhone
        case settingUpProfile
        case signedIn
    }

    init() {
        // Monitor auth state
        if authService.isAuthenticated {
            authState = .signedIn
        }
    }

    func sendVerificationCode() async {
        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter a phone number"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            // Format phone number with +1 prefix
            let formattedNumber = "+1\(phoneNumber)"
            verificationID = try await authService.verifyPhoneNumber(formattedNumber)
            authState = .verifyingPhone
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func verifyCode() async {
        guard let verificationID = verificationID, !verificationCode.isEmpty else {
            errorMessage = "Please enter the verification code"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let user = try await authService.signInWithPhone(
                verificationID: verificationID,
                verificationCode: verificationCode
            )

            // Check if user exists in Firestore
            let userExists = try? await firestoreService.fetchUser(user.uid)
            if userExists == nil {
                authState = .settingUpProfile
            } else {
                authState = .signedIn
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func signOut() {
        do {
            try authService.signOut()
            authState = .signedOut
            phoneNumber = ""
            verificationCode = ""
            verificationID = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
