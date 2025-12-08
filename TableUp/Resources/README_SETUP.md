# TableUp Setup Instructions

## Required Configuration Files

### 1. GoogleService-Info.plist
You need to add your Firebase configuration file:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Add an iOS app to your project
4. Download the `GoogleService-Info.plist` file
5. Add it to the `TableUp/Resources/` directory in Xcode

### 2. Firebase Services to Enable

In your Firebase Console, enable these services:

- **Authentication**
  - Phone Authentication
  - Google Sign-In (optional)
  - Apple Sign-In (optional)

- **Cloud Firestore**
  - Create a database in production mode
  - Deploy the security rules from the implementation guide

- **Cloud Storage**
  - Enable storage for images
  - Deploy the storage rules from the implementation guide

- **Cloud Functions** (optional for full functionality)
  - Deploy the Cloud Functions from the implementation guide

- **Cloud Messaging**
  - Enable FCM for push notifications

### 3. Swift Package Dependencies

Add these packages via Xcode (File > Add Packages):

1. **Firebase iOS SDK**
   - URL: `https://github.com/firebase/firebase-ios-sdk`
   - Products to add:
     - FirebaseAuth
     - FirebaseFirestore
     - FirebaseStorage
     - FirebaseMessaging
     - FirebaseAnalytics

### 4. Xcode Project Setup

1. Create a new Xcode project:
   - File > New > Project
   - iOS App
   - Product Name: TableUp
   - Interface: SwiftUI
   - Minimum Deployment: iOS 16.0

2. Delete the default ContentView.swift and TableUpApp.swift

3. Add all the files from this directory structure to your Xcode project

4. Add GoogleService-Info.plist to the project (make sure "Copy items if needed" is checked)

5. Enable background modes in Signing & Capabilities:
   - Background Modes > Remote notifications

### 5. Build Settings

- iOS Deployment Target: 16.0+
- Swift Language Version: 5.9+

### 6. Test the App

Once everything is set up:

1. Build the project (⌘+B)
2. Run on simulator or device (⌘+R)
3. You should see the sign-in screen

## Troubleshooting

### Build Errors
- Make sure all Firebase packages are added
- Check that GoogleService-Info.plist is in the project
- Clean build folder (⌘+Shift+K)

### Location Services
- Test on a real device for best results
- Grant location permissions when prompted

### Firebase Connection
- Check that GoogleService-Info.plist is correctly configured
- Verify Firebase services are enabled in console

## Next Steps

1. Deploy Firestore security rules
2. Deploy Cloud Storage rules
3. Set up Cloud Functions for notifications
4. Test authentication flow
5. Create some test meets and groups
6. Test on a physical device

## Support

For issues or questions, refer to:
- [Firebase Documentation](https://firebase.google.com/docs)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- The implementation guide provided
