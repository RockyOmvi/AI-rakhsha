import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AnomalyDetectorService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final VoidCallback onSosTriggered;
  Timer? _softCheckinTimer;

  AnomalyDetectorService({required this.onSosTriggered});

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Called periodically by the location tracker to send coords to the backend
  Future<void> evaluateRouteDeviation(double lat, double lng, double speed) async {
    // In a production environment, you would send this to the Backend ML Service.
    // e.g., POST /api/anomaly/evaluate
    // Here we mock the behavior of an anomaly being detected by the backend.
    
    bool isAnomalyDetected = _mockBackendEvaluation(lat, lng, speed);

    if (isAnomalyDetected) {
      if (kDebugMode) {
         print("ML Engine detected an anomaly. Initiating Soft Check-in.");
      }
      _initiateSoftCheckIn();
    }
  }

  bool _mockBackendEvaluation(double lat, double lng, double speed) {
    // Mocking an anomaly if speed suddenly drops in an unexpected zone
    // Returning true randomly for testing purposes would be bad, so we'll just mock false.
    return false; // Toggle to true to test the flow
  }

  Future<void> _initiateSoftCheckIn() async {
    // 1. Show a silent/discreet local notification
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'soft_checkin_channelId',
      'Soft Check In',
      channelDescription: 'Checks if everything is okay',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('ID_IM_OK', 'I am OK'),
      ]
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      id: 0,
      title: 'Are you okay?',
      body: 'We noticed a sudden change in your route. Tap to confirm you are safe.',
      notificationDetails: platformChannelSpecifics,
      payload: 'status_check',
    );

    // 2. Start a 60-second timer
    _softCheckinTimer?.cancel();
    _softCheckinTimer = Timer(const Duration(seconds: 60), () {
      if (kDebugMode) {
        print("User did not respond to Soft Check-in. Escalating to SOS.");
      }
      onSosTriggered(); // Auto-trigger SOS
    });
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload == 'status_check' || response.actionId == 'ID_IM_OK') {
      if (kDebugMode) {
        print("User responded to Soft Check-in. Canceling SOS escalation.");
      }
      _softCheckinTimer?.cancel();
    }
  }

  void dispose() {
    _softCheckinTimer?.cancel();
  }
}
