//
//  ProfileSetupView.swift
//  TableUp
//
//  Profile setup view
//

import SwiftUI

struct ProfileSetupView: View {
    @StateObject private var viewModel = ProfileSetupViewModel()
    @Binding var isCompleted: Bool
    @State private var showImagePicker = false

    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Title
                    VStack(spacing: 8) {
                        Text("Set up your profile")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.textPrimary)

                        Text("Tell us a bit about yourself")
                            .bodyStyle()
                    }
                    .padding(.top, 40)

                    // Photo picker
                    Button(action: { showImagePicker = true }) {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.backgroundCard)
                                .frame(width: 120, height: 120)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 30))
                                        Text("Add Photo")
                                            .captionStyle()
                                    }
                                    .foregroundColor(.textSecondary)
                                )
                        }
                    }

                    // Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .bodyStyle()

                        TextField("Your name", text: $viewModel.name)
                            .foregroundColor(.textPrimary)
                            .padding()
                            .frame(height: 56)
                            .background(Color.backgroundCard)
                            .cornerRadius(16)
                    }

                    // Bio
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bio (optional)")
                            .bodyStyle()

                        TextField("Tell us about yourself", text: $viewModel.bio, axis: .vertical)
                            .foregroundColor(.textPrimary)
                            .lineLimit(3...6)
                            .padding()
                            .background(Color.backgroundCard)
                            .cornerRadius(16)
                    }

                    // Interests
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select 3-7 interests")
                            .bodyStyle()

                        Text("\(viewModel.selectedInterests.count)/7 selected")
                            .captionStyle()

                        InterestChipsFlow(
                            interests: Constants.availableInterests,
                            selectedInterests: $viewModel.selectedInterests
                        )
                    }

                    // Continue button
                    PrimaryButton(
                        title: "Continue",
                        action: {
                            Task {
                                let success = await viewModel.createProfile()
                                if success {
                                    isCompleted = true
                                }
                            }
                        },
                        isLoading: viewModel.isLoading,
                        isDisabled: !viewModel.canContinue
                    )
                    .padding(.top, 24)

                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.accentRed)
                            .captionStyle()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.selectedImage)
        }
    }
}
