//
//  CreateMeetView.swift
//  TableUp
//
//  Create meet view
//

import SwiftUI

struct CreateMeetView: View {
    @StateObject private var viewModel = CreateMeetViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showImagePicker = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .bodyStyle()

                            TextField("What are you doing?", text: $viewModel.title)
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

                            TextField("Tell people what to expect...", text: $viewModel.description, axis: .vertical)
                                .foregroundColor(.textPrimary)
                                .lineLimit(3...6)
                                .padding()
                                .background(Color.backgroundCard)
                                .cornerRadius(16)
                        }

                        // Location
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .bodyStyle()

                            TextField("Where is this happening?", text: $viewModel.locationName)
                                .foregroundColor(.textPrimary)
                                .padding()
                                .frame(height: 56)
                                .background(Color.backgroundCard)
                                .cornerRadius(16)
                        }

                        // Date & Time
                        VStack(alignment: .leading, spacing: 12) {
                            Text("When")
                                .bodyStyle()

                            DatePicker("Start", selection: $viewModel.startTime, displayedComponents: [.date, .hourAndMinute])
                                .foregroundColor(.textPrimary)
                                .padding()
                                .background(Color.backgroundCard)
                                .cornerRadius(16)

                            DatePicker("End", selection: $viewModel.endTime, displayedComponents: [.date, .hourAndMinute])
                                .foregroundColor(.textPrimary)
                                .padding()
                                .background(Color.backgroundCard)
                                .cornerRadius(16)
                        }

                        // Capacity
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Capacity: \(viewModel.capacity)")
                                .bodyStyle()

                            Stepper("", value: $viewModel.capacity, in: 2...100)
                                .padding()
                                .background(Color.backgroundCard)
                                .cornerRadius(16)
                        }

                        // Tags
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Categories")
                                .bodyStyle()

                            InterestChipsFlow(
                                interests: Constants.meetCategories,
                                selectedInterests: $viewModel.selectedTags,
                                maxSelection: 3
                            )
                        }

                        // Photo (optional)
                        Button(action: { showImagePicker = true }) {
                            HStack {
                                Image(systemName: "photo")
                                Text(viewModel.selectedImage == nil ? "Add Photo (Optional)" : "Photo Added")
                            }
                            .foregroundColor(.primaryPurple)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.backgroundCard)
                            .cornerRadius(16)
                        }

                        // Create button
                        PrimaryButton(
                            title: "Create Meet",
                            action: {
                                Task {
                                    let success = await viewModel.createMeet()
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
            .navigationTitle("Create Meet")
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
