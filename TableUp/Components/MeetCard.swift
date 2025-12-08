//
//  MeetCard.swift
//  TableUp
//
//  Meet card component for lists
//

import SwiftUI

struct MeetCard: View {
    let meet: Meet
    let onJoin: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with time and category
            HStack {
                Text(meet.startTime.formatted(style: .time))
                    .captionStyle()

                Spacer()

                CategoryPill(category: meet.primaryTag)
            }

            // Title
            Text(meet.title)
                .titleStyle()
                .lineLimit(2)

            // Description
            if !meet.description.isEmpty {
                Text(meet.description)
                    .bodyStyle()
                    .lineLimit(2)
            }

            // Location
            HStack(spacing: 6) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.accentBlue)
                Text(meet.locationName)
                    .bodyStyle()
                    .lineLimit(1)
            }

            // Attendees and action
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.textSecondary)
                    Text("\(meet.attendeeCount)/\(meet.capacity)")
                        .captionStyle()
                }

                Spacer()

                Button(action: onJoin) {
                    Text("Join")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.primaryPurple)
                        .cornerRadius(20)
                }
            }
        }
        .padding()
        .cardStyle()
    }
}

struct CategoryPill: View {
    let category: String

    var body: some View {
        Text(category)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.forCategory(category))
            .cornerRadius(12)
    }
}
