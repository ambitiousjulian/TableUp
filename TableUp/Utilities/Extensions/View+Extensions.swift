//
//  View+Extensions.swift
//  TableUp
//
//  SwiftUI View extensions
//

import SwiftUI

extension View {
    // MARK: - Typography
    func headlineStyle() -> some View {
        self.font(.system(size: 24, weight: .bold))
            .foregroundColor(.textPrimary)
    }

    func titleStyle() -> some View {
        self.font(.system(size: 20, weight: .semibold))
            .foregroundColor(.textPrimary)
    }

    func bodyStyle() -> some View {
        self.font(.system(size: 16, weight: .regular))
            .foregroundColor(.textSecondary)
    }

    func captionStyle() -> some View {
        self.font(.system(size: 12, weight: .medium))
            .foregroundColor(.textSecondary)
    }

    func smallStyle() -> some View {
        self.font(.system(size: 10, weight: .regular))
            .foregroundColor(.textTertiary)
    }

    // MARK: - Card Style
    func cardStyle() -> some View {
        self
            .background(Color.backgroundCard)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    // MARK: - Elevated Card Style
    func elevatedCardStyle() -> some View {
        self
            .background(Color.backgroundElevated)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
    }

    // MARK: - Hide Keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // MARK: - Conditional Modifier
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    // MARK: - Loading Overlay
    func loadingOverlay(isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.overlay
                        .ignoresSafeArea()

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        }
    }
}
