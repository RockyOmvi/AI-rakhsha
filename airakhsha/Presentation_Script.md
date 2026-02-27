# AI Raksha — Presentation Script

## Slide-by-Slide Speaker Notes & Delivery Guide

**Duration:** 12–15 minutes  
**Audience:** Academic panel / hackathon judges / investor demo  

---

## Slide 1: Title Slide

**[DURATION: 30 seconds]**

> "Good [morning/afternoon], everyone. My name is Ritika Raj, and today I'm presenting **AI Raksha** — an AI-powered women's safety mobile application.
>
> The word 'Raksha' means *protection* in Hindi. And that's exactly what this app does — it turns every smartphone into an intelligent, personal safety shield.
>
> Let me walk you through the problem we're solving, how we solve it, and the technology behind it."

---

## Slide 2: The Problem

**[DURATION: 1.5 minutes]**

> "Let's start with the harsh reality. According to multiple surveys, **88% of women in India report feeling unsafe during night commutes**. That's not a statistic — that's someone's mother, daughter, or friend.
>
> Now, safety apps already exist. But they have three fundamental flaws:
>
> **First**, they require you to *manually open the app, find the button, and press it* during an emergency. When you're panicking, that's nearly impossible.
>
> **Second**, most of them depend on **internet connectivity**. No WiFi, no cellular data — no help. That's a dealbreaker.
>
> **Third**, they're **reactive, not proactive**. They wait for you to ask for help. They don't watch out for you.
>
> We asked ourselves: what if your phone could *detect danger before you even press a button?* What if it could send help *without needing the internet?* What if you had a way to *discreetly escape* an uncomfortable situation without anyone knowing? That's what AI Raksha does."

---

## Slide 3: Our Solution

**[DURATION: 1 minute]**

> "AI Raksha is a complete personal safety ecosystem — not just a panic button.
>
> It combines **six powerful features** into one app:
> - An **SOS emergency button** that activates with a 3-second hold — no typing, no unlocking menus
> - **Automatic SMS alerts** with your live Google Maps location — sent via your phone's native SMS, no internet needed
> - A **fake call feature** that creates a realistic incoming call so you can excuse yourself from dangerous situations
> - An **AI anomaly detector** that monitors your route and *checks in on you* if something seems wrong
> - **Trusted contact management** — your family gets alerted automatically
> - And **persistent emergency logs** so there's always a record
>
> All of this works **completely offline**. No cloud. No API keys. No subscriptions. Zero."

---

## Slide 4: Key Features Overview

**[DURATION: 45 seconds]**

> "Let me give you a quick visual overview of these six features before we dive deeper into each one.
>
> *(Point to each icon as you mention it)*
>
> The **SOS button** is the centerpiece — designed to be used in panic situations. **Emergency SMS** goes out the moment you trigger SOS. The **Fake Call** is designed for social engineering scenarios where you need to escape without confrontation. **AI Anomaly Detection** provides passive, hands-free protection. **Trusted Contacts** is your support network. And **Alert History** gives you an auditable trail.
>
> Now, let me show you the three standout features in detail."

---

## Slide 5: SOS Emergency Button (Deep Dive)

**[DURATION: 1.5 minutes]**

> "The SOS button is the heart of AI Raksha. It's a large, circular button with a **pulsing red glow animation** — you can't miss it.
>
> To activate, you **press and hold for 3 seconds**. As you hold, you'll see a visual countdown — 3, 2, 1 — with **haptic feedback** at every second. Light vibrations, then a strong vibration when it triggers. You feel it in your hand — you *know* it worked.
>
> Why 3 seconds? Two reasons. First, it **prevents accidental triggers** — you won't set off an emergency by bumping your phone. Second, it's **fast enough for real emergencies** — 3 seconds is all you need.
>
> Once triggered, here's what happens automatically — in under 2 seconds:
> 1. Your **GPS coordinates are captured**
> 2. An emergency event is **logged locally** with a timestamp
> 3. **SMS messages are sent** to every trusted contact with a Google Maps link of your exact location
> 4. The app starts **streaming your location every 5 seconds** so contacts can track your movement
>
> If you release before 3 seconds — nothing happens. The countdown resets. It's designed for high-stress situations where panic is real."

---

## Slide 6: Fake Call Feature

**[DURATION: 1.5 minutes]**

> "This is one of the most clever features in AI Raksha, and it's inspired by a very real need.
>
> Imagine you're in a cab that's taking an unusual route. Or you're at a gathering and someone is making you uncomfortable. You can't call for help openly — that might escalate the situation. But you need a way out.
>
> That's the **Fake Call**. You schedule a call — say, in 30 seconds — with whatever name you want. Maybe 'Dad'. Maybe 'Boss'. 
>
> 30 seconds later, your phone **rings with the actual device ringtone**. The screen looks exactly like a real incoming call — animated caller avatar, caller name and number, accept and decline buttons.
>
> You 'accept' the call, put the phone to your ear, and say: *'Hey Dad, yeah I'm coming, I'll be there in 5 minutes.'* Then you walk away.
>
> Nobody suspects anything because it looks and sounds completely real. It even shows a **running call timer** after you accept so it maintains the illusion.
>
> No other safety app I've seen integrates this as elegantly."

---

## Slide 7: AI Anomaly Detection Engine

**[DURATION: 1.5 minutes]**

> "This is where AI Raksha goes beyond a simple panic button — this is the *intelligence* in AI Raksha.
>
> The anomaly detection engine continuously evaluates three signals: your **GPS coordinates**, your **speed**, and your **route pattern**.
>
> If the ML model detects something unusual — a sudden route deviation, an unexpected stop in an unfamiliar area, or a speed drop that doesn't match the road type — it doesn't immediately trigger a panic. That would be annoying and inaccurate.
>
> Instead, it initiates what we call a **Soft Check-In**. A discreet notification pops up asking: *'Are you okay?'* There's a button that says *'I am OK'*. If you tap it, great — the system stands down.
>
> But if you **don't respond within 60 seconds** — maybe because you can't, maybe because you're in danger — the system **automatically escalates to a full SOS emergency**, sending SMS alerts to all your trusted contacts.
>
> This is **passive, hands-free protection**. You don't have to do anything. The AI watches your back.
>
> Currently, this uses a mock ML evaluation engine, but the architecture is fully ready for a TensorFlow Lite on-device model."

---

## Slide 8: Technical Architecture

**[DURATION: 1 minute]**

> "Let me quickly walk you through the technical architecture.
>
> The app is built in **five layers**:
>
> At the top, the **Presentation Layer** — 8 screens built with Flutter widgets: Onboarding, Home, Login, Register, Contacts, History, Fake Call, and Settings.
>
> Below that, the **State Management Layer** using **Riverpod 3.x**. We use NotifierProviders for synchronous state like emergencies and onboarding, and AsyncNotifierProviders for auth and contacts.
>
> The **Service Layer** contains three critical services: LocationService wrapping Geolocator for GPS, SmsService using a native MethodChannel to Android's SmsManager, and the AnomalyDetectorService with Flutter Local Notifications.
>
> The **Data Layer** uses Hive for structured local storage — users, contacts, emergency history — and SharedPreferences for simple flags.
>
> And the **Platform Layer** — we wrote native Kotlin code in MainActivity.kt to handle SMS sending through Android's SmsManager API, because third-party Flutter SMS packages were unreliable."

---

## Slide 9: Technology Stack

**[DURATION: 45 seconds]**

> "Our technology stack is designed for reliability and zero external dependencies:
>
> - **Flutter** for cross-platform mobile development
> - **Riverpod 3.x** for reactive, testable state management
> - **GoRouter** for declarative routing with authentication guards
> - **Hive** for fast, lightweight local storage
> - **Geolocator** for real-time GPS tracking
> - **OpenStreetMap** for maps — completely free, no API key needed
> - And **native Android Kotlin** for reliable background SMS sending
>
> The entire app works offline. No Firebase. No cloud functions. No backend servers for core functionality. This is by design — because safety should never depend on a WiFi signal."

---

## Slide 10: App Screens Showcase

**[DURATION: 45 seconds]**

> "Here's a visual tour of the app screens.
>
> *(Point to each mockup)*
>
> The **Onboarding** introduces new users to the four key features with clean page indicators.
>
> The **Home Screen** centers everything around the SOS button with quick action buttons below for Fake Call, Contacts, History, and Settings.
>
> The **Fake Call screen** perfectly mimics a real incoming call.
>
> The **Contacts screen** lets you manage your safety network with swipe-to-delete.
>
> And the **History screen** shows every emergency event with timestamps and status badges."

---

## Slide 11: Offline-First & Privacy

**[DURATION: 1 minute]**

> "Privacy is not a feature of AI Raksha — it's the **foundation**.
>
> Here's our promise: **no data leaves your phone. Period.**
>
> All user data — contacts, emergency history, authentication — is stored locally in Hive on the device. There are no analytics SDKs. No crash reporting to external servers. No Google Sign-In. No Firebase.
>
> SMS is sent through your phone's carrier network using the native Android SmsManager — not through the internet. This means you could have your data turned off entirely, and the SOS system would still work.
>
> GPS uses your device's hardware directly, not a cloud geolocation service.
>
> In a world where every app is harvesting data, AI Raksha takes the opposite approach. Your safety data belongs to you and you alone."

---

## Slide 12: Future Roadmap

**[DURATION: 1 minute]**

> "We have an ambitious roadmap for AI Raksha.
>
> In the **near term**: we're integrating a **TensorFlow Lite model** for real on-device anomaly detection, adding a **shake-to-SOS** gesture trigger, and integrating **emergency helpline quick-dial** for 100, 112, and 1091.
>
> In the **medium term**: a **live location dashboard** for trusted contacts to view your position during an emergency through a web portal, a **smartwatch companion app** for WearOS, and **voice-activated SOS** with a custom wake word.
>
> And in the **long term**: a **community safety heatmap** using anonymized crowd-sourced data to help women identify safe and risky areas in real time, **audio/video evidence recording** during emergencies, and **multi-language support** for Hindi and 8 other regional languages.
>
> Each of these builds on the modular architecture we already have in place."

---

## Slide 13: Impact & Vision

**[DURATION: 1 minute]**

> "Our vision for AI Raksha is simple but powerful: **make personal safety proactive, not reactive**.
>
> We want every woman to have a silent, intelligent guardian in her pocket. Not an app she has to remember to open. Not a button she has to fumble for. But a system that **watches, learns, and acts** before she even has to ask.
>
> Our target is **1 million downloads** in the first year, partnering with:
> - Women's safety **NGOs** for grassroots distribution
> - **University campuses** for student safety programs
> - **Corporate HR** departments for employee safety initiatives
> - **Smart City government programs** for municipal safety infrastructure
>
> The modular architecture allows us to customize the app for each partner's specific needs while maintaining the core safety engine."

---

## Slide 14: Thank You / Closing

**[DURATION: 30 seconds]**

> "I'll leave you with this thought:
>
> **'Safety shouldn't be an afterthought — it should be an instinct. AI Raksha makes your phone your shield.'**
>
> Thank you for your time and attention. I'm happy to answer any questions or give a live demo of the app.
>
> Thank you."

---

## Q&A Preparation — Anticipated Questions

### Q: "How is this different from apps like bSafe or Shake2Safety?"
> "Most existing safety apps are notification-based — they send alerts via internet. AI Raksha sends SMS via the native carrier network, works 100% offline, includes AI-based anomaly detection with auto-escalation, and integrates a realistic fake call feature. The combination of all six features in one offline-first app is unique."

### Q: "What about false positives in the anomaly detection?"
> "The soft check-in mechanism is specifically designed for this. When the AI detects something, it doesn't immediately trigger SOS — it asks you first. False positives result in a simple notification tap. Only 60 seconds of no response triggers the escalation. This two-step process balances sensitivity with accuracy."

### Q: "Will this work on iOS?"
> "Flutter is cross-platform, so the UI and business logic works identically. The SMS MethodChannel would need a corresponding Swift implementation for iOS, which is on our roadmap. For the initial release, we're targeting Android where 85%+ of our target demographic is."

### Q: "How do you handle the SMS cost to users?"
> "SMS is sent via the user's existing carrier plan. Most Indian mobile plans include free SMS or very low per-message costs. In an emergency, the cost of 3-5 SMS messages is negligible compared to the value of safety."

### Q: "What if the user's phone is taken away?"
> "The continuous location streaming (every 5s) means that even if the phone is taken away after SOS is triggered, the last known locations are still available. Additionally, the anomaly detector can auto-trigger SOS based on route deviation before the user even realizes there's danger. For the future, we're working on audio recording capabilities."

---

## Presentation Tips

- **Demo:** If possible, run the app on an Android phone and demonstrate the SOS button, fake call, and contacts screen live
- **Pacing:** Spend most time on Slides 5, 6, and 7 (the three hero features)
- **Tone:** Start serious (problem), shift to hopeful (solution), end empowering (vision)
- **Eye Contact:** Look at the audience during the impact statistics and closing quote
- **Backup:** Have a screen recording of the app ready in case the live demo fails
