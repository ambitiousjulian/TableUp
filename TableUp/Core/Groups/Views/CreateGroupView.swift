//
//  CreateGroupView.swift
//  TableUp
//
//  Create group view
//

import SwiftUI

struct CreateGroupView: View {
    @StateObject private var viewModel = CreateGroupViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showImagePicker = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Group Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Group Name")
                                .bodyStyle()

                            TextField("e.g., Miami Tech Enthusiasts", text: $viewModel.name)
                                .foregroundColor(.textPrimary)
                                .padding()
                                .frame(height: 56)
                                .background(Color.backgroundCard)
                                .cornerRadius(16)
                        }

                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .bodyStyle()

                            TextField("What's your group about?", text: $viewModel.description, axis: .vertical)
                                .foregroundColor(.textPrimary)
                                .lineLimit(3...6)
                                .padding()
                                .background(Color.backgroundCard)
                                .cornerRadius(16)
                        }

                        // Interests/Tags
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Interests")
                                .bodyStyle()

                            InterestChipsFlow(
                                interests: Constants.availableInterests,
                                selectedInterests: $viewModel.selectedTags,
                                maxSelection: 5
                            )
                        }

                        // Privacy Setting
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle(isOn: $viewModel.isPrivate) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Private Group")
                                        .bodyStyle()
                                    Text("Only members you approve can join")
                                        .captionStyle()
                                }
                            }
                            .tint(.primaryPurple)
                            .padding()
                            .background(Color.backgroundCard)
                            .cornerRadius(16)
                        }

                        // Group Photo (optional)
                        Button(action: { showImagePicker = true }) {
                            HStack {
                                Image(systemName: "photo")
                                Text(viewModel.selectedImage == nil ? "Add Group Photo (Optional)" : "Photo Added")
                            }
                            .foregroundColor(.primaryPurple)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.backgroundCard)
                            .cornerRadius(16)
                        }

                        // Create button
                        PrimaryButton(
                            title: "Create Group",
                            action: {
                                Task {
                                    let success = await viewModel.createGroup()
                                    if success {
                                        dismiss()
                                    }
                                }
                            },
                            isLoading: viewModel.isLoading,
                            isDisabled: !viewModel.canCreate
                        )
                        .padding(.top, 16)

                        // Error
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.accentRed)
                                .captionStyle()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Create Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.selectedImage)
        }
    }
}
