//
//  LocationSearchView.swift
//  TableUp
//
//  Location search UI with dropdown results
//

import SwiftUI
import MapKit

struct LocationSearchView: View {
    @StateObject private var viewModel = LocationSearchViewModel()
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var locationName: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search field
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textSecondary)

                        TextField("Search for a place...", text: $viewModel.searchQuery)
                            .foregroundColor(.textPrimary)
                            .autocorrectionDisabled()

                        if !viewModel.searchQuery.isEmpty {
                            Button(action: { viewModel.searchQuery = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.backgroundCard)
                    .cornerRadius(12)
                    .padding()

                    // Selected location
                    if let location = viewModel.selectedLocation {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentGreen)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(location.name)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.textPrimary)

                                    Text(location.address)
                                        .captionStyle()
                                }

                                Spacer()

                                Button(action: {
                                    viewModel.clearSelection()
                                }) {
                                    Text("Change")
                                        .foregroundColor(.primaryPurple)
                                        .font(.system(size: 14, weight: .medium))
                                }
                            }
                            .padding()
                            .background(Color.backgroundCard)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)

                        Spacer()

                        // Confirm button
                        PrimaryButton(
                            title: "Use This Location",
                            action: {
                                selectedLocation = location.coordinate
                                locationName = "\(location.name) - \(location.address)"
                                dismiss()
                            }
                        )
                        .padding()
                    } else {
                        // Search results
                        if viewModel.searchResults.isEmpty && !viewModel.searchQuery.isEmpty {
                            EmptyStateView(
                                icon: "magnifyingglass",
                                title: "No results",
                                message: "Try searching for a different location"
                            )
                        } else {
                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(viewModel.searchResults, id: \.self) { result in
                                        LocationResultRow(result: result) {
                                            Task {
                                                await viewModel.selectLocation(result)
                                            }
                                        }
                                        Divider()
                                            .background(Color.backgroundElevated)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Location")
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
    }
}

struct LocationResultRow: View {
    let result: MKLocalSearchCompletion
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.primaryPurple)
                    .font(.system(size: 20))

                VStack(alignment: .leading, spacing: 4) {
                    Text(result.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textPrimary)

                    if !result.subtitle.isEmpty {
                        Text(result.subtitle)
                            .captionStyle()
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.textTertiary)
                    .font(.system(size: 12))
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
