//
//  AuthService.swift
//  TableUp
//
//  Authentication service wrapper for Firebase Auth
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
class AuthService: ObservableObject {
    static let shared = AuthService()

    @Published var currentUser: FirebaseAuth.User?
    @Published var isAuthenticated = false

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    private init() {
        setupAuthStateListener()
    }

    func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }

    // MARK: - Phone Authentication
    func verifyPhoneNumber(_ phoneNumber: String) async throws -> String {
        return try await PhoneAuthProvider.provider().verifyPhoneNumber(
            phoneNumber,
            uiDelegate: nil
        )
    }

    func signInWithPhone(verificationID: String, verificationCode: String) async throws -> FirebaseAuth.User {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        let result = try await Auth.auth().signIn(with: credential)
        return result.user
    }

    // MARK: - Social Authentication
    func signInWithGoogle() async throws -> FirebaseAuth.User {
        // TODO: Implement Google Sign In
        throw NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }

    func signInWithApple() async throws -> FirebaseAuth.User {
        // TODO: Implement Apple Sign In
        throw NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }

    // MARK: - Sign Out
    func signOut() throws {
        try Auth.auth().signOut()
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
