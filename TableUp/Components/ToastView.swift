//
//  ToastView.swift
//  TableUp
//
//  Toast notification component
//

import SwiftUI

enum ToastStyle {
    case success
    case error
    case info

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return .accentGreen
        case .error: return .accentRed
        case .info: return .accentBlue
        }
    }
}

struct ToastMessage: Equatable {
    let message: String
    let style: ToastStyle

    static func == (lhs: ToastMessage, rhs: ToastMessage) -> Bool {
        lhs.message == rhs.message
    }
}

struct ToastView: View {
    let message: String
    let style: ToastStyle
    @Binding var isShowing: Bool

    var body: some View {
        VStack {
            Spacer()

            if isShowing {
                HStack(spacing: 12) {
                    Image(systemName: style.icon)
                        .font(.system(size: 20))
                        .foregroundColor(style.color)

                    Text(message)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textPrimary)

                    Spacer()
                }
                .padding()
                .background(Color.backgroundElevated)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isShowing)
            }
        }
        .onChange(of: isShowing) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isShowing = false
                    }
                }
            }
        }
    }
}

// Toast modifier for easy usage
struct ToastModifier: ViewModifier {
    @Binding var toast: ToastMessage?
    @State private var isShowing = false

    func body(content: Content) -> some View {
        ZStack {
            content

            if let toast = toast {
                ToastView(message: toast.message, style: toast.style, isShowing: $isShowing)
            }
        }
        .onChange(of: toast) { _, newValue in
            withAnimation {
                isShowing = newValue != nil
            }
        }
        .onChange(of: isShowing) { _, newValue in
            if !newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    toast = nil
                }
            }
        }
    }
}

extension View {
    func toast(_ toast: Binding<ToastMessage?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
