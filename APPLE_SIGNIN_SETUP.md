# Apple Sign In - iOS Setup Guide

## Overview
This document contains step-by-step instructions for configuring Apple Sign In when you're ready to test on iOS devices or deploy to the App Store.

**Note:** The code is already implemented in the app. You just need to configure the iOS project and Apple Developer settings.

---

## Prerequisites

Before setting up Apple Sign In, you'll need:

1. ✅ **Apple Developer Account** ($99/year)
   - Sign up at: https://developer.apple.com/programs/

2. ✅ **Mac computer with Xcode** (for iOS development)
   - Or access to macOS for configuration

3. ✅ **iOS Device or Simulator** (for testing)
   - iOS 13.0 or later required

---

## Step 1: Apple Developer Portal Configuration

### 1.1 Create App ID

1. Go to https://developer.apple.com/account/
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers** → **+** button
4. Select **App IDs** → Continue
5. Fill in:
   - **Description:** Short Notes Trainer
   - **Bundle ID:** `com.yourcompany.shortnoteapp1` (match your app's bundle ID)
   - ⚠️ **IMPORTANT:** Check the exact bundle ID in `ios/Runner.xcodeproj/project.pbxproj`

6. Under **Capabilities**, enable:
   - ✅ **Sign in with Apple**

7. Click **Continue** → **Register**

### 1.2 Create Service ID (for Web Authentication)

1. In Identifiers, click **+** button
2. Select **Services IDs** → Continue
3. Fill in:
   - **Description:** Short Notes Trainer Service
   - **Identifier:** `com.yourcompany.shortnoteapp1.service`

4. Check **Sign in with Apple**
5. Click **Configure** next to Sign in with Apple:
   - **Primary App ID:** Select your app ID from Step 1.1
   - **Domains and Subdomains:** `your-app.com` (or your actual domain)
   - **Return URLs:** `https://your-app.com/callbacks/sign_in_with_apple`

6. Click **Save** → **Continue** → **Register**

⚠️ **Note:** Update the following values in the code later:
- In `login_screen.dart` and `signup_screen.dart`
- Replace `com.yourcompany.shortnoteapp1.service` with your actual Service ID
- Replace `https://your-app.com/callbacks/sign_in_with_apple` with your redirect URL

---

## Step 2: Xcode Project Configuration

### 2.1 Enable Sign in with Apple Capability

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** project in the left sidebar
3. Select **Runner** target
4. Go to **Signing & Capabilities** tab
5. Click **+ Capability**
6. Search for and add **Sign in with Apple**

### 2.2 Update Info.plist (if needed)

The package should handle this automatically, but verify `ios/Runner/Info.plist` doesn't have conflicting entries.

### 2.3 Update Bundle Identifier

1. In Xcode, go to **General** tab
2. Verify **Bundle Identifier** matches what you set in Apple Developer Portal
3. Recommended: `com.yourcompany.shortnoteapp1`

---

## Step 3: Update Code with Your Values

### 3.1 Update Login Screen

Open `lib/screens/login_screen.dart` and update:

```dart
webAuthenticationOptions: WebAuthenticationOptions(
  clientId: 'com.yourcompany.shortnoteapp1.service', // ← Your Service ID
  redirectUri: Uri.parse('https://your-app.com/callbacks/sign_in_with_apple'), // ← Your redirect URL
),
```

### 3.2 Update Signup Screen

Open `lib/screens/signup_screen.dart` and update the same values.

### 3.3 Recommended Values

**For Development/Testing:**
```dart
clientId: 'your.actual.bundle.id.service'
redirectUri: Uri.parse('https://localhost/callbacks/sign_in_with_apple')
```

**For Production:**
```dart
clientId: 'your.actual.bundle.id.service'
redirectUri: Uri.parse('https://yourdomain.com/callbacks/sign_in_with_apple')
```

---

## Step 4: Testing

### 4.1 Test on iOS Simulator

1. Build and run the app on iOS Simulator (iOS 13+)
2. Navigate to Login or Signup screen
3. You should see the **"Sign in with Apple"** button (black)
4. Tap the button
5. Apple Sign In dialog should appear
6. Enter your Apple ID credentials
7. App should create account and log you in

### 4.2 Test on Physical iOS Device

1. Connect your iPhone/iPad
2. Build and run the app
3. Test Apple Sign In flow
4. Verify user data is stored correctly

### 4.3 Test Email Privacy

Apple allows users to hide their real email:
- ✅ **Share My Email:** App receives real email
- ✅ **Hide My Email:** App receives private relay email
  - Format: `xxxxx@privaterelay.apple.icloud.com`
  - ⚠️ You can only send emails to this address through Apple

Test both options to ensure your app handles them correctly.

---

## Step 5: App Store Submission

### 5.1 Requirements

When submitting to App Store with Apple Sign In:

1. ✅ App must include Sign in with Apple capability
2. ✅ Button must follow Apple's design guidelines (package handles this)
3. ✅ Must respect user's email privacy choice
4. ✅ Must not require additional account creation after Apple Sign In

### 5.2 Review Guidelines

Apple will check:
- Sign in with Apple button is visible
- Button works correctly
- No friction after sign in
- Privacy policy mentions Apple Sign In

---

## Platform Availability

### Current Implementation

```dart
// Login/Signup screens show Apple button only on iOS
if (Platform.isIOS) ...[
  _buildAppleSignInButton(),
],
```

**Behavior:**
- **iOS:** Shows Apple Sign In button ✅
- **Android:** Button is hidden ✅
- **Web:** Button is hidden (could be enabled with web support)
- **macOS:** Shows Apple Sign In button ✅

### To Enable on Android (Optional)

Android support is possible but complex:
1. Requires web authentication flow
2. Less seamless than iOS
3. Not recommended unless necessary

**Recommendation:** Keep iOS-only. Android users can use:
- Email/Password signup
- Guest mode
- (Future: Google Sign In)

---

## Troubleshooting

### Issue: Button doesn't appear on iOS

**Check:**
1. Xcode capability is enabled
2. Running on iOS 13.0+ simulator/device
3. `Platform.isIOS` check is working

### Issue: Sign In fails with error

**Common causes:**
1. Service ID not configured correctly
2. Redirect URI mismatch
3. App ID capability not enabled
4. Bundle ID doesn't match

**Solution:**
- Check Apple Developer Portal configuration
- Verify all IDs match between code and portal
- Check Xcode console for detailed error messages

### Issue: Email is null

**This is normal:**
- User chose "Hide My Email"
- App receives private relay email instead
- Code handles this: `$appleUserId@privaterelay.appleid.com`

### Issue: Name is null on subsequent logins

**This is normal:**
- Apple only provides name on FIRST sign in
- Store the name from first login
- Use stored name for future logins

---

## Security Considerations

### 1. Token Verification (Recommended for Production)

For enhanced security, verify Apple ID tokens:

```dart
// Server-side verification
POST https://appleid.apple.com/auth/token
// Verify the identity token returned by Apple
```

### 2. User Identifier Storage

- Store `credential.userIdentifier` as unique user ID
- Use it to identify returning users
- Don't rely solely on email (it can be hidden)

### 3. Private Relay Emails

- Private relay emails are forwarded by Apple
- Can be revoked by user at any time
- Plan for users changing their email preferences

---

## Code Structure

### Files Modified

1. ✅ `pubspec.yaml` - Added `sign_in_with_apple: ^6.1.3`
2. ✅ `lib/screens/login_screen.dart` - Apple Sign In button + handler
3. ✅ `lib/screens/signup_screen.dart` - Apple Sign In button + handler
4. ✅ `lib/models/user.dart` - Ready to handle Apple users
5. ✅ `lib/services/storage_service.dart` - Stores Apple user credentials

### How It Works

```
User taps "Sign in with Apple"
         ↓
SignInWithApple.getAppleIDCredential()
         ↓
Apple authentication dialog
         ↓
User authenticates with Apple ID
         ↓
App receives: userIdentifier, email, name
         ↓
Check if user exists (by email)
         ↓
If new: Create UserAuth account
If existing: Log them in
         ↓
Navigate to main app
```

### Data Stored

```dart
UserAuth(
  email: credential.email ?? '${appleUserId}@privaterelay.appleid.com',
  password: appleUserId, // Apple user ID (not used for login)
  fullName: '${givenName} ${familyName}',
  profilePicturePath: null, // Apple doesn't provide photos
)
```

---

## Testing Checklist

When you're ready to test on iOS:

- [ ] Apple Developer Account created
- [ ] App ID registered with Sign in with Apple capability
- [ ] Service ID configured
- [ ] Xcode capability enabled
- [ ] clientId and redirectUri updated in code
- [ ] App builds successfully on iOS
- [ ] Apple Sign In button appears
- [ ] Tapping button shows Apple authentication
- [ ] New user account creation works
- [ ] Returning user login works
- [ ] Email privacy (hide/show) works
- [ ] User data displays correctly in profile
- [ ] All app features work for Apple users

---

## Future Enhancements

### Option 1: Add Keychain Storage

Store Apple credentials securely:
```dart
// Use flutter_secure_storage
// Store userIdentifier and tokens in iOS Keychain
```

### Option 2: Token Refresh

Implement token refresh for long-term sessions:
```dart
// Use refresh token to maintain login state
// Prevent frequent re-authentication
```

### Option 3: Account Linking

Allow users to link Apple ID to existing email account:
```dart
// If email matches, offer to link accounts
// Combine progress from both accounts
```

---

## Support

For issues or questions:
- Apple Sign In Docs: https://developer.apple.com/sign-in-with-apple/
- Package Docs: https://pub.dev/packages/sign_in_with_apple
- Flutter Docs: https://docs.flutter.dev/deployment/ios

---

## Important Notes

⚠️ **Remember:**
- Apple Sign In only works on **iOS/macOS**
- Requires **iOS 13.0+** (released September 2019)
- **Mandatory** if you offer other social logins (Google, Facebook)
- Must follow **Apple's Human Interface Guidelines**
- Test thoroughly before App Store submission

✅ **Your app is now ready for Apple Sign In!**

When you get an iOS device or access to a Mac:
1. Follow this guide
2. Configure Apple Developer Portal
3. Update Xcode project
4. Update clientId/redirectUri in code
5. Test on iOS
6. Submit to App Store

Good luck! 🍎

