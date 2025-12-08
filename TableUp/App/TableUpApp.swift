//
//  TableUpApp.swift
//  TableUp
//
//  Main app entry point
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
struct TableUpApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()

        // Setup notification center delegate
        UNUserNotificationCenter.current().delegate = NotificationService.shared

        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Handle FCM token
        Messaging.messaging().apnsToken = deviceToken
    }
}
