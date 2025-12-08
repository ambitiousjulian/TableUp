//
//  SignInView.swift
//  TableUp
//
//  Sign in view
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Logo/Title
                VStack(spacing: 8) {
                    Text("TableUp")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primaryPurple)

                    Text("Connect IRL, Near You")
                        .bodyStyle()
                }
                .padding(.bottom, 40)

                // Phone number input
                VStack(alignment: .leading, spacing: 12) {
                    Text("Enter your phone number")
                        .bodyStyle()

                    HStack {
                        Text("+1")
                            .foregroundColor(.textSecondary)
                            .padding(.leading, 16)

                        TextField("(555) 123-4567", text: $viewModel.phoneNumber)
                            .keyboardType(.phonePad)
                            .foregroundColor(.textPrimary)
                    }
                    .frame(height: 56)
                    .background(Color.backgroundCard)
                    .cornerRadius(16)
                }

                // Send code button
                PrimaryButton(
                    title: "Send Code",
                    action: {
                        Task {
                            await viewModel.sendVerificationCode()
                        }
                    },
                    isLoading: viewModel.isLoading,
                    isDisabled: viewModel.phoneNumber.isEmpty
                )

                // Error message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.accentRed)
                        .captionStyle()
                }

                Spacer()

                // Terms
                Text("By continuing, you agree to our Terms & Privacy Policy")
                    .captionStyle()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
    }
}
