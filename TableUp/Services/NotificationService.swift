//
//  NotificationService.swift
//  TableUp
//
//  Firebase Cloud Messaging service
//

import Foundation
import FirebaseMessaging
import UserNotifications

@MainActor
class NotificationService: NSObject, ObservableObject {
    static let shared = NotificationService()

    @Published var fcmToken: String?
    @Published var notificationPermissionGranted = false

    override init() {
        super.init()
    }

    func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            self.notificationPermissionGranted = granted

            if granted {
                await registerForRemoteNotifications()
            }
        } catch {
            print("Error requesting notification permission: \(error)")
        }
    }

    @MainActor
    private func registerForRemoteNotifications() async {
        await UIApplication.shared.registerForRemoteNotifications()
    }

    func updateFCMToken(_ token: String) {
        self.fcmToken = token
        // TODO: Save to Firestore user document
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle notification tap
        completionHandler()
    }
}
