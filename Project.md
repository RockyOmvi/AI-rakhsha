# AI Raksha – Intelligent Women Safety & Emergency Response System
## Flutter/Dart Production Architecture Documentation

---

# 1. Project Overview

AI Raksha is a cross-platform mobile safety application built using Flutter and Dart.  
The application provides:

- One-tap emergency alert
- Real-time live location streaming
- Fake call simulation
- Trusted contacts notification
- Incident logging
- AI-based anomaly detection (future enhancement)
- Offline fallback mechanisms

The app is designed to be production-ready, scalable, and secure.

---

# 2. Technology Stack

## 2.1 Frontend (Mobile App)
- Framework: Flutter
- Language: Dart
- State Management: Riverpod / Bloc (recommended)
- Navigation: GoRouter
- Maps: Google Maps Flutter SDK
- Local Storage: Hive / SharedPreferences
- Secure Storage: flutter_secure_storage

## 2.2 Backend
- Node.js (Express.js) OR Firebase Cloud Functions
- REST APIs
- WebSocket (Socket.io) OR Firebase Realtime Database
- Authentication: JWT / Firebase Auth

## 2.3 Database
- Primary: MongoDB Atlas
OR
- Firebase Firestore

## 2.4 Real-Time Communication
- WebSocket (Socket.io)
OR
- Firebase Realtime Database

---

# 3. App UI/UX Design

## 3.1 Home Screen Layout

### Components:

1. Large SOS Emergency Button (center)
2. Fake Call Button
3. Live Location Toggle Switch
4. Trusted Contacts Shortcut
5. Alert History
6. Profile & Settings

---

## 3.2 Design Guidelines

Color Palette:
- Primary: Red (#FF3B3B)
- Secondary: Navy Blue (#0F172A)
- Accent: Yellow (#FFD700)
- Background: White / Soft Grey

Emergency Button:
- Circular
- Pulsating animation
- 3-second long press to activate
- Haptic feedback on activation

---

# 4. Flutter Application Architecture

Recommended Architecture: Clean Architecture

lib/
│
├── core/
│   ├── constants/
│   ├── utils/
│   ├── services/
│
├── features/
│   ├── auth/
│   ├── emergency/
│   ├── location/
│   ├── contacts/
│   ├── fake_call/
│
├── models/
├── repositories/
├── data_sources/
├── main.dart

---

# 5. Frontend Functional Flow

---

# 5.1 SOS Emergency Button

### UI Behavior:
- Long press (3 seconds)
- Countdown animation
- Confirmation vibration

### On Activation:

1. Fetch current GPS location
2. Call API: POST /api/emergency/trigger
3. Open WebSocket connection
4. Start streaming location every 5 seconds
5. Notify trusted contacts
6. Log incident locally

### Dart Implementation Flow:

- Use geolocator package
- Use http or dio for API
- Use socket_io_client for WebSocket

---

# 5.2 Live Location Streaming

After emergency activation:

Timer.periodic(Duration(seconds: 5)):
- Get GPS
- Emit via WebSocket
- Save to local storage
- Update backend

WebSocket Event:
"location:update"

Payload:
{
  userId,
  latitude,
  longitude,
  accuracy,
  timestamp
}

---

# 5.3 Fake Call Feature

Purpose:
Allows user to simulate an incoming call.

Flow:
1. Select delay (10s / 30s / 1 min)
2. Timer starts
3. Full-screen fake incoming call UI appears
4. Ringtone plays
5. User can accept/reject call

Implementation:
- Custom full-screen route
- Audio playback using audioplayers package
- Timer class

---

# 5.4 Trusted Contacts Management

User can:
- Add contact
- Remove contact
- Edit contact

Data stored:
- In database
- Cached locally in Hive

API:
POST /api/contacts/add
DELETE /api/contacts/remove
GET /api/contacts/:userId

---

# 6. Backend API Structure

---

# 6.1 Authentication APIs

POST /api/auth/register  
POST /api/auth/login  
GET /api/auth/profile  

JWT stored securely using flutter_secure_storage.

---

# 6.2 Emergency APIs

POST /api/emergency/trigger  
POST /api/emergency/resolve  
GET /api/emergency/history/:userId  

---

# 6.3 Location APIs

POST /api/location/update  
GET /api/location/latest/:userId  

---

# 7. Database Schema (MongoDB)

---

## 7.1 Users Collection

{
  _id: ObjectId,
  name: String,
  email: String,
  phone: String,
  passwordHash: String,
  trustedContacts: [
    {
      name: String,
      phone: String,
      relation: String
    }
  ],
  createdAt: Date
}

---

## 7.2 Emergency Logs Collection

{
  _id: ObjectId,
  userId: ObjectId,
  status: "ACTIVE" | "RESOLVED",
  triggeredAt: Date,
  resolvedAt: Date,
  initialLocation: {
    latitude: Number,
    longitude: Number
  }
}

---

## 7.3 Location Streams Collection

{
  _id: ObjectId,
  emergencyId: ObjectId,
  latitude: Number,
  longitude: Number,
  timestamp: Date
}

---

# 8. WebSocket Architecture

## 8.1 Connection Flow

1. User logs in
2. JWT validated
3. Socket connects
4. User joins room:
   room:user_<userId>

## 8.2 Events

"emergency:start"  
"location:update"  
"emergency:resolve"

---

# 9. Offline & Fallback Strategy

---

## 9.1 If Internet Fails

1. Store emergency locally in Hive
2. Trigger SMS fallback (using native plugin)
3. Retry API every 10 seconds
4. Sync once internet restores

---

## 9.2 WebSocket Fallback

If socket disconnects:
- Switch to REST polling
GET /api/location/latest/:userId
- Attempt reconnection

---

# 10. Security Implementation

- HTTPS enforced
- JWT authentication
- Secure token storage
- API rate limiting
- Input validation
- Data encryption at rest (MongoDB Atlas)

---

# 11. Admin Dashboard (Web-Based)

Admin can:
- View active emergencies
- Track live map locations
- Resolve emergency
- View analytics

Built using:
- React or Flutter Web
- Google Maps API
- WebSocket connection

---

# 12. Performance Optimization

- Throttle GPS updates
- Lazy loading screens
- Minimize widget rebuilds
- Use const constructors
- Index MongoDB on:
  - userId
  - emergencyId
  - timestamp

---

# 13. Future Enhancements

- Shake-to-alert detection
- Voice activation ("Help Raksha")
- AI behavior analysis
- Smart wearable integration
- Nearby police station auto-routing
- Audio recording during emergency

---

# 14. Deployment Plan

Mobile App:
- Android (Play Store)
- iOS (App Store)

Backend:
- Render / AWS EC2

Database:
- MongoDB Atlas

Environment Variables:
- JWT_SECRET
- DB_URI
- GOOGLE_MAPS_API_KEY
- SMS_API_KEY

---

# 15. Conclusion

AI Raksha is a scalable, secure, real-time women safety mobile application built using Flutter and Dart.

Core Strengths:
- Cross-platform support
- Real-time GPS tracking
- Emergency broadcast system
- Offline fallback safety
- Secure authentication
- Scalable backend architecture

The system is production-ready and designed for real-world deployment.