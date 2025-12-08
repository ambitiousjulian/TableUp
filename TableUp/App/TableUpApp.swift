//
//  TableUpApp.swift
//  TableUp
//
//  Main app entry point
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
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
        
        // Register for remote notifications
        application.registerForRemoteNotifications()

        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Pass to both Auth and Messaging
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Let Firebase Auth handle phone auth notifications
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        completionHandler(.newData)
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        // Handle Firebase Auth URL redirects
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
}
