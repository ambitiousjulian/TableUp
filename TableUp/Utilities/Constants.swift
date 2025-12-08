//
//  Constants.swift
//  TableUp
//
//  App-wide constants
//

import Foundation

struct Constants {
    // MARK: - App Info
    static let appName = "TableUp"
    static let appVersion = "1.0.0"

    // MARK: - Map
    static let defaultMapRadius: Double = 10.0 // km
    static let defaultMapZoom: Double = 0.05

    // MARK: - Meets
    static let maxMeetCapacity = 100
    static let defaultMeetDuration: TimeInterval = 2 * 3600 // 2 hours

    // MARK: - Interests
    static let availableInterests = [
        "Tech", "Startup", "AI", "Crypto",
        "Sports", "Fitness", "Running", "Yoga",
        "Food", "Coffee", "Nightlife", "Wine",
        "Art", "Music", "Photography", "Design",
        "Books", "Writing", "Gaming", "Anime",
        "Travel", "Hiking", "Beach", "Nature",
        "Social Impact", "Volunteering", "Environment"
    ]

    // MARK: - Meet Categories
    static let meetCategories = [
        "Tech", "Social", "Fitness", "Culture",
        "Food & Drink", "Sports", "Outdoors", "Learning"
    ]

    // MARK: - Pagination
    static let defaultPageSize = 20
    static let maxLoadLimit = 100

    // MARK: - Image
    static let maxImageSizeMB: Double = 5.0
    static let imageCompressionQuality: CGFloat = 0.7

    // MARK: - Timeouts
    static let requestTimeout: TimeInterval = 30
    static let locationTimeout: TimeInterval = 10
}
