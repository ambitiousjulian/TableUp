//
//  MeetCard.swift
//  TableUp
//
//  Meet card component for lists
//

import SwiftUI

struct MeetCard: View {
    let meet: Meet

    var body: some View {
        if let meetId = meet.id {
            NavigationLink(destination: MeetDetailView(meetId: meetId)) {
                cardContent
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            cardContent
        }
    }
    
    private var cardContent: some View {
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

            // Attendees
            HStack(spacing: 4) {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.textSecondary)
                Text("\(meet.attendeeCount)/\(meet.capacity)")
                    .captionStyle()
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
