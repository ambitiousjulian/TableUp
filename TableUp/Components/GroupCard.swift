//
//  GroupCard.swift
//  TableUp
//
//  Group card component for lists
//

import SwiftUI

struct GroupCard: View {
    let group: Group
    var onTap: (() -> Void)? = nil

    var body: some View {
        let content = HStack(spacing: 12) {
            // Group photo
            if let photoURL = group.photoURL {
                AsyncImage(url: URL(string: photoURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Color.backgroundElevated)
                        .overlay(
                            Image(systemName: "person.3.fill")
                                .foregroundColor(.textSecondary)
                        )
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundElevated)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.textSecondary)
                    )
            }

            // Group info
            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                Text(group.description)
                    .bodyStyle()
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "person.2")
                        .font(.system(size: 10))
                    Text("\(group.memberCount) members")
                        .captionStyle()
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.textTertiary)
                .font(.system(size: 14))
        }
        .padding()
        .cardStyle()
        
        if let groupId = group.id {
            NavigationLink(destination: GroupDetailView(groupId: groupId)) {
                content
            }
            .buttonStyle(PlainButtonStyle())
        } else if let onTap = onTap {
            Button(action: onTap) {
                content
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            content
        }
    }
}
