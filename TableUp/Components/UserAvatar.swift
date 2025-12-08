//
//  UserAvatar.swift
//  TableUp
//
//  User avatar component
//

import SwiftUI

struct UserAvatar: View {
    let photoURL: String?
    let size: CGFloat
    var borderColor: Color?

    init(photoURL: String?, size: CGFloat = 40, borderColor: Color? = nil) {
        self.photoURL = photoURL
        self.size = size
        self.borderColor = borderColor
    }

    var body: some View {
        Group {
            if let photoURL = photoURL, let url = URL(string: photoURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    placeholderView
                }
            } else {
                placeholderView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(borderColor ?? .clear, lineWidth: 2)
        )
    }

    private var placeholderView: some View {
        Circle()
            .fill(Color.backgroundElevated)
            .overlay(
                Image(systemName: "person.fill")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: size * 0.5))
            )
    }
}
