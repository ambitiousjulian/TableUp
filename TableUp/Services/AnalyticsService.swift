//
//  AnalyticsService.swift
//  TableUp
//
//  Firebase Analytics service
//

import Foundation
import FirebaseAnalytics

class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    // MARK: - Meet Events
    func logMeetCreated(category: String, capacity: Int) {
        Analytics.logEvent("meet_created", parameters: [
            "category": category,
            "capacity": capacity
        ])
    }

    func logMeetJoined(meetId: String, category: String) {
        Analytics.logEvent("meet_joined", parameters: [
            "meet_id": meetId,
            "category": category
        ])
    }

    func logMeetLeft(meetId: String) {
        Analytics.logEvent("meet_left", parameters: [
            "meet_id": meetId
        ])
    }

    // MARK: - Group Events
    func logGroupCreated(category: String) {
        Analytics.logEvent("group_created", parameters: [
            "category": category
        ])
    }

    func logGroupJoined(groupId: String) {
        Analytics.logEvent("group_joined", parameters: [
            "group_id": groupId
        ])
    }

    // MARK: - Search Events
    func logSearchPerformed(query: String, filterType: String?) {
        Analytics.logEvent("search_performed", parameters: [
            "query": query,
            "filter": filterType ?? "none"
        ])
    }

    // MARK: - Map Events
    func logMapFilterUsed(filter: String) {
        Analytics.logEvent("map_filter_used", parameters: [
            "filter": filter
        ])
    }

    // MARK: - Screen Views
    func logScreenView(screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
    }
}
