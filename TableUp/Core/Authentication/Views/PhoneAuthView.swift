//
//  PhoneAuthView.swift
//  TableUp
//
//  Phone verification view
//

import SwiftUI

struct PhoneAuthView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Title
                VStack(spacing: 8) {
                    Text("Verify your number")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.textPrimary)

                    Text("Enter the code sent to \(viewModel.phoneNumber)")
                        .bodyStyle()
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 40)

                // Verification code input
                TextField("123456", text: $viewModel.verificationCode)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .frame(height: 56)
                    .background(Color.backgroundCard)
                    .cornerRadius(16)

                // Verify button
                PrimaryButton(
                    title: "Verify",
                    action: {
                        Task {
                            await viewModel.verifyCode()
                        }
                    },
                    isLoading: viewModel.isLoading,
                    isDisabled: viewModel.verificationCode.isEmpty
                )

                // Resend code
                Button(action: {
                    Task {
                        await viewModel.sendVerificationCode()
                    }
                }) {
                    Text("Resend code")
                        .foregroundColor(.primaryPurple)
                        .captionStyle()
                }

                // Error message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.accentRed)
                        .captionStyle()
                }

                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}
