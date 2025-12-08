//
//  PrimaryButton.swift
//  TableUp
//
//  Primary action button component
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var backgroundColor: Color = .primaryPurple

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(isDisabled ? backgroundColor.opacity(0.5) : backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(16)
        }
        .disabled(isLoading || isDisabled)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.backgroundCard)
                .foregroundColor(.textPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.divider, lineWidth: 1)
                )
                .cornerRadius(16)
        }
        .disabled(isDisabled)
    }
}
