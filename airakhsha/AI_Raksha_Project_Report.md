# AI Raksha — Project Report

## Comprehensive Technical & Functional Documentation

**Project Name:** AI Raksha (AI रक्षा — "AI Protection")  
**Version:** 1.0.0+1  
**Platform:** Android (Flutter cross-platform)  
**Date:** February 2026  
**Author:** Purusharth  

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Problem Statement](#2-problem-statement)
3. [Proposed Solution](#3-proposed-solution)
4. [Features in Detail](#4-features-in-detail)
5. [System Architecture](#5-system-architecture)
6. [Technology Stack](#6-technology-stack)
7. [Module Breakdown](#7-module-breakdown)
8. [Data Flow & State Management](#8-data-flow--state-management)
9. [Security & Privacy](#9-security--privacy)
10. [Testing & Verification](#10-testing--verification)
11. [Challenges & Solutions](#11-challenges--solutions)
12. [Future Scope](#12-future-scope)
13. [Conclusion](#13-conclusion)

---

## 1. Executive Summary

**AI Raksha** is an AI-powered women's safety mobile application built using the Flutter framework. It provides a comprehensive personal safety ecosystem that combines an **instant SOS emergency alert system**, **AI-driven anomaly detection**, a **fake call escape mechanism**, **automatic SMS alerts with live GPS location**, **trusted contact management**, and **persistent alert history** — all engineered to function **completely offline** with **zero cloud dependencies**.

The application's name "Raksha" (रक्षा) means "protection" in Hindi, symbolizing the app's core mission: to serve as an intelligent, ever-ready guardian for women. The "AI" prefix signifies the integration of machine learning algorithms for proactive threat detection through route anomaly analysis.

The app is designed with a **mobile-first, privacy-first** philosophy. All user data is stored locally on the device using Hive (a lightweight NoSQL database), and SMS alerts are sent through the device's native SMS infrastructure via Android's `SmsManager` API, ensuring functionality even without an internet connection.

---

## 2. Problem Statement

Women's safety remains a critical and pervasive challenge, particularly in developing countries. Key statistics and observations include:

- **88% of women** in urban India report feeling unsafe during night commutes (source: various safety surveys).
- **Existing safety apps** suffer from critical limitations:
  - They require the user to **manually interact** with the phone during an emergency — which may be impractical or impossible when in real danger.
  - Most rely on **internet connectivity** for alerts, making them unreliable in areas with poor network coverage.
  - Many demand **API keys, subscriptions, or cloud services**, adding cost and dependency barriers.
  - Very few provide **proactive threat detection** — they are purely reactive, waiting for the user to press a button.
  - **Fake call features**, which can be lifesaving in uncomfortable social situations, are rarely integrated into safety apps.

### Core Challenges Addressed

| Challenge | AI Raksha's Approach |
|---|---|
| Manual interaction required during panic | 3-second hold SOS with haptic countdown — no typing needed |
| Internet dependency for alerts | Direct SMS via native `SmsManager` API — works offline |
| No proactive detection | AI anomaly detector monitors route and auto-escalates |
| No discreet escape mechanism | Fake call feature with realistic ringtone and UI |
| Cloud/API key dependency | 100% local — Hive DB, SharedPreferences, OpenStreetMap |
| Data privacy concerns | All data stored on-device; nothing leaves the phone |

---

## 3. Proposed Solution

AI Raksha addresses every challenge identified above through a layered, multi-feature safety ecosystem:

### 3.1 One-Tap Emergency System
A centrally positioned SOS button with a **3-second hold-to-activate** mechanism provides an intuitive yet accidental-press-proof emergency trigger. Upon activation, the system automatically:
1. Captures the user's GPS coordinates
2. Logs the emergency event to local storage with a timestamp
3. Sends SMS alerts to all trusted contacts with a Google Maps link
4. Begins continuous location streaming every 5 seconds

### 3.2 AI-Powered Anomaly Detection
An integrated ML engine (currently a mock implementation with architecture ready for TensorFlow Lite integration) continuously evaluates GPS data, speed, and route patterns. When the engine detects anomalous behavior (sudden route deviation, unexpected stops, speed drops in high-risk zones), it initiates a discreet **"Soft Check-In"** via a silent notification asking *"Are you okay?"* with a 60-second response window. If the user does not respond, the system automatically escalates to a full SOS emergency — providing **passive, hands-free protection**.

### 3.3 Fake Call Escape
Users can schedule a realistic fake incoming phone call with a customizable caller name, phone number, and time delay (10 seconds to 5 minutes). The fake call screen mimics the native Android call interface with a real device ringtone, animated caller avatar, accept/decline buttons, and a running call duration timer.

### 3.4 Trusted Contact Network
Users can manage a list of trusted contacts (family, friends, guardians) with name, phone number, and relationship details. These contacts are automatically alerted via SMS during any emergency.

### 3.5 Alert History & Logs
Every emergency event — including activation time, GPS coordinates, and resolution status — is persistently stored in Hive and displayed in a dedicated History screen. This provides an auditable trail that can be useful for legal or counselling purposes.

---

## 4. Features in Detail

### 4.1 SOS Emergency Button

| Attribute | Detail |
|---|---|
| **Activation** | Long-press and hold for 3 seconds |
| **Visual Feedback** | Circular progress ring fills over 3 seconds |
| **Haptic Feedback** | Light impact each second; heavy impact on trigger |
| **Countdown Display** | Large countdown number (3 → 2 → 1) on button face |
| **Idle Animation** | Pulsing red glow effect (1.5s cycle) around button |
| **Cancellation** | Release before 3s to abort — no accidental triggers |

#### Trigger Workflow:
```
User holds SOS 3s → Haptic + Visual Countdown
  → GPS capture (Geolocator)
  → Log emergency to Hive (with lat/lng + timestamp)
  → Send SMS to all trusted contacts (native SmsManager)
  → Start 5-second location streaming loop
  → Display emergency banner on Home screen
```

### 4.2 Fake Call System

| Attribute | Detail |
|---|---|
| **Customizable Fields** | Caller name, phone number |
| **Delay Options** | 10 seconds, 30 seconds, 1 minute, 5 minutes |
| **Ringtone** | Device's default ringtone via `FlutterRingtonePlayer` |
| **UI Elements** | Animated caller avatar, incoming call text, accept/decline buttons |
| **On Accept** | Ringtone stops, running call timer starts (MM:SS) |
| **On Decline/End** | Ringtone stops, user returns to home screen |

### 4.3 AI Anomaly Detection

| Attribute | Detail |
|---|---|
| **Input Data** | Latitude, longitude, speed |
| **Evaluation** | Periodic backend call (mock, ready for ML model) |
| **Alert Type** | Silent "Soft Check-In" local notification |
| **Response Window** | 60 seconds |
| **No Response** | Auto-escalates to full SOS emergency |
| **User Confirmation** | Tap "I am OK" button on notification to cancel |

### 4.4 Trusted Contacts

| Attribute | Detail |
|---|---|
| **Fields** | Name, phone number, relation |
| **Storage** | Hive local NoSQL database |
| **Add** | Dialog with text fields + validation |
| **Delete** | Swipe-to-dismiss with Dismissible widget |
| **Max Contacts** | Unlimited |
| **Auto-Alert** | All contacts receive SMS during emergency |

### 4.5 Emergency SMS

| Attribute | Detail |
|---|---|
| **Mechanism** | Native Android `SmsManager` via MethodChannel |
| **Permission** | Runtime `SEND_SMS` permission request |
| **Fallback** | Opens SMS app via `url_launcher` if permission denied |
| **Content** | "🚨 EMERGENCY! I need help! My location: [Google Maps link]" |
| **Multi-Recipient** | Iterates through all trusted contacts |
| **Multi-Part** | Supports messages > 160 characters via `divideMessage()` |

### 4.6 Alert History

| Attribute | Detail |
|---|---|
| **Storage** | Hive box (`emergency_history`) |
| **Recorded Data** | Emergency ID, timestamp, latitude, longitude, status |
| **Status Values** | "active" (ongoing) / "resolved" (ended) |
| **UI** | List view with date, coordinates, and status badges |
| **Auto-Refresh** | Provider invalidated on trigger/resolve for real-time updates |

### 4.7 Onboarding Flow

| Attribute | Detail |
|---|---|
| **Pages** | 4 swipeable pages with icons and descriptions |
| **Topics Covered** | App overview, SOS Button, Trusted Contacts, Fake Call |
| **Navigation** | Next button, page indicators, Skip button |
| **Completion** | SharedPreferences flag + NotifierProvider (synchronous) |
| **One-Time** | Never shown again after "Get Started" is tapped |

### 4.8 Authentication

| Attribute | Detail |
|---|---|
| **Screens** | Login + Register |
| **Storage** | Hive local database |
| **State** | Riverpod AsyncNotifierProvider |
| **Status** | authenticated / unauthenticated |
| **Router Integration** | GoRouter redirect guards ensure logged-in users skip auth screens |

---

## 5. System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                         │
│                                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │Onboarding│  │   Home   │  │ Contacts │  │ History  │     │
│  │  Screen  │  │  Screen  │  │  Screen  │  │  Screen  │     │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │  Login   │  │ Register │  │Fake Call  │  │ Settings │     │
│  │  Screen  │  │  Screen  │  │  Screen  │  │  Screen  │     │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘     │
│              ┌──────────────────────┐                         │
│              │   SOS Button Widget  │                         │
│              │ (Pulsing + Countdown)│                         │
│              └──────────────────────┘                         │
├─────────────────────────────────────────────────────────────┤
│                  STATE MANAGEMENT LAYER                       │
│                    (Flutter Riverpod 3.x)                     │
│                                                               │
│  ┌──────────────┐  ┌───────────────┐  ┌───────────────┐     │
│  │  Auth         │  │  Emergency     │  │  Contacts      │     │
│  │  Provider     │  │  Provider      │  │  Provider      │     │
│  │(AsyncNotifier)│  │  (Notifier)    │  │(AsyncNotifier) │     │
│  └──────────────┘  └───────────────┘  └───────────────┘     │
│  ┌──────────────┐  ┌───────────────┐                         │
│  │  Onboarding   │  │   GoRouter     │                         │
│  │  Provider     │  │   Provider     │                         │
│  │  (Notifier)   │  │  (redirect)    │                         │
│  └──────────────┘  └───────────────┘                         │
├─────────────────────────────────────────────────────────────┤
│                     SERVICE LAYER                             │
│                                                               │
│  ┌──────────────┐  ┌───────────────┐  ┌───────────────┐     │
│  │  Location     │  │     SMS        │  │   Anomaly      │     │
│  │  Service      │  │   Service      │  │  Detector      │     │
│  │ (Geolocator)  │  │(MethodChannel) │  │  Service       │     │
│  └──────────────┘  └───────────────┘  └───────────────┘     │
├─────────────────────────────────────────────────────────────┤
│                      DATA LAYER                               │
│                                                               │
│  ┌──────────────────────┐  ┌──────────────────────┐         │
│  │        Hive           │  │  SharedPreferences    │         │
│  │  (Users, Contacts,    │  │  (Onboarding flag)    │         │
│  │   Emergency History)  │  │                       │         │
│  └──────────────────────┘  └──────────────────────┘         │
├─────────────────────────────────────────────────────────────┤
│                   PLATFORM LAYER (Native)                     │
│                                                               │
│  ┌──────────────────────────────────────────────────┐       │
│  │    Android (Kotlin) — MainActivity.kt             │       │
│  │    MethodChannel: com.airakhsha/sms               │       │
│  │    → SmsManager.getDefault().sendMultipartText()  │       │
│  └──────────────────────────────────────────────────┘       │
│  ┌──────────────────────────────────────────────────┐       │
│  │    AndroidManifest.xml                            │       │
│  │    Permissions: SEND_SMS, READ_PHONE_STATE,       │       │
│  │    INTERNET, ACCESS_FINE_LOCATION,                │       │
│  │    ACCESS_COARSE_LOCATION                         │       │
│  └──────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Technology Stack

| Component | Technology | Version | Purpose |
|---|---|---|---|
| Framework | Flutter | 3.x | Cross-platform mobile UI |
| Language | Dart | ^3.9.2 | Application logic |
| State Management | Flutter Riverpod | 3.2.1 | Reactive state with Notifiers |
| Navigation | GoRouter | 17.1.0 | Declarative routing with redirect guards |
| Local Database | Hive | 2.2.3 | Lightweight NoSQL for contacts, history, users |
| Preferences | SharedPreferences | 2.5.4 | Simple key-value (onboarding flag) |
| GPS | Geolocator | 14.0.2 | Real-time location tracking |
| Maps | Flutter Map + LatLong2 | 7.0.2 / 0.9.1 | OpenStreetMap rendering (no API key) |
| SMS (Native) | Android SmsManager | - | Direct background SMS via MethodChannel |
| Permissions | Permission Handler | 11.3.1 | Runtime permission requests |
| Notifications | Flutter Local Notifications | 20.1.0 | Soft check-in alerts |
| Ringtone | Flutter Ringtone Player | 4.0.0+4 | Fake call ringtone playback |
| HTTP | http | 1.6.0 | Network requests (for future ML backend) |
| URL Launcher | url_launcher | 6.3.1 | Fallback SMS & external links |
| Native Layer | Kotlin | - | MainActivity.kt for MethodChannel SMS handler |
| App Icon | flutter_launcher_icons | latest | Auto-generation of adaptive launcher icons |

---

## 7. Module Breakdown

The codebase follows a **feature-first architecture** with 22 Dart files organized into 7 feature modules and 4 core modules.

### 7.1 Core Modules

| Module | Files | Responsibility |
|---|---|---|
| `core/constants` | `app_colors.dart` | Color palette, gradients, theme tokens |
| `core/theme` | `app_theme.dart` | Material dark theme configuration |
| `core/router` | `app_router.dart` | GoRouter, route definitions, redirect logic, onboarding provider |
| `core/services` | `local_storage_service.dart`, `location_service.dart`, `sms_service.dart` | Hive CRUD, Geolocator wrapper, native SMS |

### 7.2 Feature Modules

| Module | Files | Key Components |
|---|---|---|
| `auth` | `auth_provider.dart`, `login_screen.dart`, `register_screen.dart` | Authentication logic, login/register UI |
| `contacts` | `contact_model.dart`, `contacts_provider.dart`, `contacts_screen.dart` | TrustedContact model, CRUD provider, contacts list UI |
| `emergency` | `emergency_provider.dart`, `home_screen.dart`, `fake_call_screen.dart`, `sos_button.dart` | Emergency workflow, SOS button widget, fake call UI |
| `history` | `history_screen.dart` | Emergency history list with status badges |
| `location` | `anomaly_detector.dart`, `places_service.dart` | AI anomaly detection, places/POI service |
| `onboarding` | `onboarding_screen.dart` | 4-page onboarding with page indicators |
| `profile` | `settings_screen.dart` | User settings and preferences |

---

## 8. Data Flow & State Management

### 8.1 Riverpod Provider Architecture

AI Raksha uses **Riverpod 3.x** with the following provider hierarchy:

```dart
// Synchronous state providers
onboardingCompleteProvider      → NotifierProvider<OnboardingNotifier, bool>

// Async data providers  
authProvider                    → AsyncNotifierProvider<AuthNotifier, AuthState>
contactsNotifierProvider        → AsyncNotifierProvider<ContactsNotifier, List<TrustedContact>>
emergencyHistoryProvider        → FutureProvider<List<Map<String, dynamic>>>

// Synchronous business logic providers
emergencyProvider               → NotifierProvider<EmergencyNotifier, EmergencyData>
localStorageProvider            → Provider<LocalStorageService>

// Router provider
appRouterProvider               → Provider<GoRouter>
```

### 8.2 Emergency Data Flow

```
User holds SOS button (3s)
    │
    ▼
SosButton.onTrigger() callback fires
    │
    ▼
EmergencyNotifier.triggerEmergency()
    ├── state = EmergencyState.active
    ├── LocationService.getCurrentLocation() → Position
    ├── LocalStorageService.logEmergency(lat, lng) → emergencyId
    ├── ref.invalidate(emergencyHistoryProvider) → History refreshes
    ├── Timer.periodic(5s) → continuous location streaming
    └── SmsService.sendSosSms(phones, location)
            ├── Check SEND_SMS permission
            ├── MethodChannel → sendSms (native Kotlin)
            │       └── SmsManager.sendMultipartTextMessage()
            └── Fallback: url_launcher sms: URI
```

### 8.3 Router Redirect Logic

```
GoRouter redirect evaluation:
    │
    ├─ onboardingDone == false → redirect to /onboarding
    │
    ├─ onboardingDone == true
    │       ├─ authState == null → no redirect (still loading)
    │       ├─ NOT authenticated + NOT on auth page → redirect to /login
    │       └─ authenticated + on auth/onboarding page → redirect to /home
    │
    └─ Otherwise → null (no redirect)
```

---

## 9. Security & Privacy

### 9.1 Privacy-First Design

| Principle | Implementation |
|---|---|
| **Local-only data** | All data stored in Hive on device; no cloud sync |
| **No telemetry** | No analytics SDK, no crash reporting to external servers |
| **No API keys** | OpenStreetMap is free; no Google Maps API key required |
| **Direct SMS** | Messages sent via carrier network, not internet |
| **Minimal permissions** | Only SEND_SMS, location, and phone state |
| **No account linking** | Auth is local; no Google/social sign-in needed |

### 9.2 Android Permissions

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.SEND_SMS" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

All sensitive permissions (`SEND_SMS`) are requested at **runtime** using the `permission_handler` package, with fallback flows if the user declines.

---

## 10. Testing & Verification

### 10.1 Build Verification

| Check | Status | Command |
|---|---|---|
| Flutter Analyze | ✅ 0 issues | `flutter analyze` |
| Debug Build | ✅ Successful | `flutter build apk --debug` |
| Release Build | ✅ Successful (48 MB) | `flutter build apk --release` |

### 10.2 Feature Testing (Manual)

| Feature | Test Scenario | Result |
|---|---|---|
| **SOS Button** | Hold for 3s → verify GPS + SMS + history log | ✅ Pass |
| **Fake Call** | Schedule 10s delay → verify ringtone + accept/decline | ✅ Pass |
| **SMS Sending** | Trigger SOS with contacts → verify SMS received | ✅ Pass |
| **Alert History** | Trigger + resolve → verify History screen updates | ✅ Pass |
| **Onboarding** | Complete 4 pages → "Get Started" → navigate to Login | ✅ Pass |
| **App Icon** | Install APK → verify custom logo in launcher | ✅ Pass |
| **Trusted Contacts** | Add/delete contacts → persist after app restart | ✅ Pass |

---

## 11. Challenges & Solutions

### Challenge 1: SMS Not Sending in Background
**Problem:** The original `url_launcher` approach with `sms:` URI only opened the SMS app without sending. Users had to manually press "Send" — useless in an emergency.  
**Solution:** Implemented a **native Android MethodChannel** in Kotlin (`MainActivity.kt`) that directly invokes `SmsManager.getDefault().sendMultipartTextMessage()`. This sends SMS silently in the background with no user interaction, while maintaining a `url_launcher` fallback if SMS permission is denied.

### Challenge 2: Onboarding Loop Bug
**Problem:** The `onboardingCompleteProvider` was a `FutureProvider` that asynchronously read from `SharedPreferences`. When invalidated after onboarding completion, it temporarily returned `null` (loading state), which defaulted to `false`, causing the GoRouter redirect to send the user back to `/onboarding` in an infinite loop.  
**Solution:** Replaced with a **synchronous `NotifierProvider`** (`OnboardingNotifier`). The SharedPreferences value is read once during `main()` before `runApp()` and the notifier is seeded synchronously — eliminating the async loading gap entirely.

### Challenge 3: Alert History Not Updating
**Problem:** The `emergencyHistoryProvider` (`FutureProvider`) cached its result after the first fetch and never refreshed when new emergencies were logged or resolved.  
**Solution:** Added `ref.invalidate(emergencyHistoryProvider)` calls in both `triggerEmergency()` and `resolveEmergency()` methods, ensuring the provider re-fetches data from Hive whenever the emergency state changes.

### Challenge 4: App Icon Showing Default Flutter Logo
**Problem:** The `mipmap-*` folders contained the default Flutter `ic_launcher.png` instead of the app's custom red lotus logo.  
**Solution:** Integrated the `flutter_launcher_icons` package, configured it to use `assets/logo.png`, and ran the icon generation command to populate all density buckets correctly.

---

## 12. Future Scope

| Enhancement | Description | Priority |
|---|---|---|
| **On-Device ML Model** | TensorFlow Lite model for real-time route anomaly classification | High |
| **Shake-to-SOS** | Accelerometer-based trigger — shake phone urgently to activate SOS | High |
| **Live Location Dashboard** | Web portal for trusted contacts to view live location during emergency | Medium |
| **Emergency Helpline Integration** | One-tap dial to 100 (Police), 112 (Emergency), 1091 (Women's Helpline) | High |
| **Smartwatch Companion** | WearOS app with one-tap SOS from wrist | Medium |
| **Voice-Activated SOS** | "Hey Raksha" wake word for hands-free trigger | Medium |
| **Community Heatmap** | Anonymized crowd-sourced safety heatmap for cities | Low |
| **Audio/Video Evidence** | Auto-record ambient audio/video during emergency as evidence | Medium |
| **Multi-Language Support** | Hindi, Tamil, Telugu, Bengali, and other regional languages | Medium |
| **iOS Production Build** | Full iOS support with equivalent features | High |

---

## 13. Conclusion

AI Raksha represents a significant step forward in the domain of personal safety technology. By combining an **intuitive SOS emergency system** with **AI-driven anomaly detection**, **discreet escape mechanisms**, and a **privacy-first architecture**, the application provides a comprehensive safety net that works reliably without internet connectivity, without cloud dependencies, and without requiring any subscription or API key.

The application's technical foundation — built on Flutter with Riverpod state management, native Android MethodChannel integration, and local Hive storage — ensures performance, reliability, and maintainability. The modular feature-first architecture enables rapid iteration and easy addition of new safety features.

AI Raksha is more than an app — it is a **silent, intelligent guardian** that transforms every smartphone into a personal safety shield.

---

> **"Safety shouldn't be an afterthought — it should be an instinct. AI Raksha makes your phone your shield."**
