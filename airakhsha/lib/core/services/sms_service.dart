import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class SmsService {
  static const MethodChannel _channel = MethodChannel('com.airakhsha/sms');

  /// Send SOS SMS with location to all recipients.
  ///
  /// Uses Android's native SmsManager via MethodChannel to send SMS
  /// directly in the background without opening the SMS app.
  /// Falls back to the `sms:` URI intent if permission is denied.
  Future<void> sendSosSms(List<String> recipients, String locationData) async {
    final String message =
        '🚨 EMERGENCY! I need help urgently!\n\n'
        '📍 My location:\n$locationData\n\n'
        '— AI Raksha SOS';

    // 1. Request SMS permission
    final status = await Permission.sms.request();

    if (status.isGranted) {
      if (kDebugMode) debugPrint('✅ SMS permission granted, sending directly...');
      try {
        for (final phone in recipients) {
          final result = await _channel.invokeMethod('sendSms', {
            'phone': phone,
            'message': message,
          });
          if (kDebugMode) debugPrint('📱 Direct SMS sent to $phone: $result');
        }
        return; // Success
      } catch (e) {
        if (kDebugMode) debugPrint('Direct SMS Error: $e');
        // Fall through to intent method
      }
    } else {
      if (kDebugMode) debugPrint('⚠️ SMS permission denied, falling back to intent...');
    }

    // 2. Fallback: Use sms: URI intent (opens SMS app)
    try {
      for (final phone in recipients) {
        final Uri smsUri = Uri(
          scheme: 'sms',
          path: phone,
          queryParameters: {'body': message},
        );

        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
          if (kDebugMode) debugPrint('📱 SMS intent opened for $phone');
        } else {
          if (kDebugMode) debugPrint('Could not launch SMS intent for $phone');
        }
      }
    } catch (error) {
      if (kDebugMode) debugPrint('SMS Intent Error: $error');

      // Last-resort fallback: try a single combined SMS intent
      try {
        final Uri fallbackUri = Uri(
          scheme: 'sms',
          path: recipients.join(','),
          queryParameters: {'body': message},
        );
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('SMS final fallback also failed: $e');
      }
    }
  }
}
