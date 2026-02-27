# Gamma Presentation Prompt — AI Raksha

> **Paste this prompt into Gamma.app to auto-generate a polished presentation.**

---

Create a 14-slide professional presentation for a mobile application called **"AI Raksha"** — an AI-powered women's safety application built with Flutter (Dart).

**Design Style:** Dark, modern, tech-forward aesthetic. Use deep navy/charcoal backgrounds with vivid red (#FF3B3B) as the primary accent color and soft cyan (#64DBDB) as the secondary accent. Use clean sans-serif fonts (Inter or Outfit). Include subtle gradients and glassmorphism-style card elements. The mood should feel empowering, trustworthy, and cutting-edge.

---

## Slide Structure:

**Slide 1 — Title Slide**
Title: "AI Raksha — Your Intelligent Safety Companion"
Subtitle: "AI-Powered Women's Safety App | Built with Flutter"
Include a shield icon and a lotus motif.

**Slide 2 — The Problem**
Women's safety in India remains a critical concern. 88% of women feel unsafe during night commutes. Existing safety apps require manual interaction during emergencies, which is impractical in real danger. Most apps lack intelligent threat detection and rely solely on user-initiated actions.

**Slide 3 — Our Solution**
AI Raksha is a mobile-first personal safety companion that combines an instant SOS alert system, AI-driven anomaly detection, smart soft check-in notifications, automatic emergency SMS with live GPS, a fake call escape mechanism, and trusted contact management — all in one app with zero API key dependencies.

**Slide 4 — Key Features Overview**
Show 6 feature icons in a grid:
1. 🚨 SOS Emergency Button (3-second hold-to-activate with haptic countdown)
2. 📱 Automatic Emergency SMS (sends live Google Maps location link)
3. 📞 Fake Call Escape (realistic incoming call with ringtone and timer)
4. 🤖 AI Anomaly Detection (ML-based route deviation analysis with soft check-in)
5. 👥 Trusted Contacts Management (add, edit, swipe-to-delete)
6. 📊 Alert History & Logs (persistent local storage with Hive)

**Slide 5 — SOS Emergency Button (Deep Dive)**
The centrepiece of the app. A large circular button with a pulsing red glow animation. User holds for 3 seconds with a visual countdown and haptic feedback at each second. On trigger: captures GPS location → logs emergency to Hive storage → sends SMS to all trusted contacts with a Google Maps link → starts continuous 5-second location streaming. The entire workflow is fully automated and requires no internet.

**Slide 6 — Fake Call Feature**
Users can schedule a fake incoming phone call with customizable caller name, number, and delay (10s, 30s, 1min, 5min). The screen mimics the native Android call UI with a realistic ringtone, accept/decline buttons, and a running call timer. Designed for discreetly exiting uncomfortable or dangerous situations.

**Slide 7 — AI Anomaly Detection Engine**
The ML engine monitors GPS coordinates, speed, and route patterns. If a route deviation or sudden speed drop is detected, a "soft check-in" silent notification is triggered asking "Are you okay?". If the user does not respond within 60 seconds, the system auto-escalates to a full SOS emergency. This provides passive protection without constant user interaction.

**Slide 8 — Technical Architecture**
Show a layered architecture diagram:
- Presentation Layer: Flutter UI with Riverpod state management + GoRouter navigation
- Business Logic Layer: Emergency Provider, Auth Provider, Contacts Provider (all Riverpod Notifiers)
- Service Layer: LocationService (Geolocator), SmsService (Native Android MethodChannel → SmsManager), AnomalyDetectorService (ML mock + Flutter Local Notifications)
- Data Layer: Hive (local NoSQL storage), SharedPreferences (onboarding/auth state)
- Platform Layer: Native Kotlin (SMS via MethodChannel), AndroidManifest permissions

**Slide 9 — Technology Stack**
Display logos/icons for:
- **Framework:** Flutter 3.x (Dart)
- **State Management:** Flutter Riverpod 3.x (NotifierProviders)
- **Navigation:** GoRouter with dynamic redirects
- **Local Storage:** Hive (NoSQL) + SharedPreferences
- **Location:** Geolocator (GPS)
- **Maps:** Flutter Map + OpenStreetMap (free, no API key)
- **SMS:** Native Android SmsManager via MethodChannel
- **Notifications:** Flutter Local Notifications
- **Design:** Custom dark theme with glassmorphism

**Slide 10 — App Screens Showcase**
Show mockup screenshots of:
1. Onboarding screen with page indicators
2. Home screen with SOS button and quick actions
3. Fake call incoming screen with accept/decline
4. Trusted contacts list
5. Emergency history log

**Slide 11 — Offline-First & Privacy**
AI Raksha works 100% offline for core features (SOS, SMS, location, fake call). Zero cloud dependencies — no Firebase, no external APIs. All data is stored locally on the device using Hive. No user data leaves the phone. SMS is sent via the device's native SmsManager, ensuring delivery even without internet. Location is tracked using device GPS only.

**Slide 12 — Future Roadmap**
1. Live ML model integration with TensorFlow Lite for on-device anomaly detection
2. Shake-to-SOS gesture trigger
3. Real-time location sharing dashboard for trusted contacts
4. Integration with local emergency helplines (100, 112, 1091)
5. Wearable device (smartwatch) companion app
6. Voice-activated SOS via "Hey Raksha" wake word
7. Community safety heatmap using anonymized data

**Slide 13 — Impact & Vision**
AI Raksha aims to empower every woman with a silent, intelligent guardian. The vision: make personal safety proactive, not reactive. Target: 1 million downloads in the first year. Partnership targets: Women's safety NGOs, university campuses, corporate employee safety programs, government Smart City initiatives.

**Slide 14 — Thank You / Contact**
"Safety shouldn't be an afterthought — it should be an instinct. AI Raksha makes your phone your shield."
Contact details placeholder. GitHub repository link.

---

**Additional Instructions:**
- Make each slide visually rich with icons, illustrations, or abstract tech graphics.
- Use a dark theme (navy/charcoal base) with red accents throughout.
- Add subtle animations for transitions if supported.
- Keep text concise; use bullet points and visuals over paragraphs.
