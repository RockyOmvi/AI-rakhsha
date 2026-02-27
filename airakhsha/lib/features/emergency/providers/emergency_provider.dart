import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../core/services/location_service.dart';
import '../../../core/services/sms_service.dart';
import '../../auth/providers/auth_provider.dart';

enum EmergencyState { inactive, active }

class EmergencyData {
  final EmergencyState status;
  final String? emergencyId;
  final String? currentLocation;
  final bool isLocationStreaming;

  const EmergencyData({
    this.status = EmergencyState.inactive,
    this.emergencyId,
    this.currentLocation,
    this.isLocationStreaming = false,
  });

  EmergencyData copyWith({
    EmergencyState? status,
    String? emergencyId,
    bool clearEmergencyId = false,
    String? currentLocation,
    bool? isLocationStreaming,
  }) {
    return EmergencyData(
      status: status ?? this.status,
      emergencyId: clearEmergencyId ? null : (emergencyId ?? this.emergencyId),
      currentLocation: currentLocation ?? this.currentLocation,
      isLocationStreaming: isLocationStreaming ?? this.isLocationStreaming,
    );
  }
}

class EmergencyNotifier extends Notifier<EmergencyData> {
  final LocationService _locationService = LocationService();
  final SmsService _smsService = SmsService();
  Timer? _locationTimer;

  @override
  EmergencyData build() {
    ref.onDispose(() => _locationTimer?.cancel());
    return const EmergencyData();
  }

  Future<void> triggerEmergency() async {
    if (state.status == EmergencyState.active) return;

    state = state.copyWith(status: EmergencyState.active);
    if (kDebugMode) debugPrint("🚨 EMERGENCY ACTIVATED");

    final storage = ref.read(localStorageProvider);

    // 1. Get current location
    final position = await _locationService.getCurrentLocation();
    String locationText = "Location unavailable";

    if (position != null) {
      locationText = "https://maps.google.com/?q=${position.latitude},${position.longitude}";
      state = state.copyWith(currentLocation: locationText);

      // 2. Log emergency locally
      final emergencyId = await storage.logEmergency(position.latitude, position.longitude);
      state = state.copyWith(emergencyId: emergencyId);
      ref.invalidate(emergencyHistoryProvider);

      // 3. Start streaming location every 5s
      state = state.copyWith(isLocationStreaming: true);
      _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        if (state.status != EmergencyState.active) {
          timer.cancel();
          return;
        }
        final pos = await _locationService.getCurrentLocation();
        if (pos != null && kDebugMode) {
          debugPrint("📍 Location: ${pos.latitude}, ${pos.longitude}");
        }
      });
    }

    // 4. Send SMS to trusted contacts
    try {
      final contacts = await storage.getTrustedContacts();
      if (contacts.isNotEmpty) {
        final phones = contacts.map((c) => c.phone).toList();
        await _smsService.sendSosSms(phones, locationText);
        if (kDebugMode) debugPrint("📱 SMS sent to ${phones.length} contacts");
      }
    } catch (e) {
      if (kDebugMode) debugPrint("SMS Error: $e");
    }

    if (kDebugMode) debugPrint("✅ Emergency workflow complete");
  }

  Future<void> resolveEmergency() async {
    _locationTimer?.cancel();

    final storage = ref.read(localStorageProvider);
    if (state.emergencyId != null) {
      await storage.resolveEmergency(state.emergencyId!);
      ref.invalidate(emergencyHistoryProvider);
    }

    state = state.copyWith(
      status: EmergencyState.inactive,
      isLocationStreaming: false,
      clearEmergencyId: true,
    );
    if (kDebugMode) debugPrint("✅ EMERGENCY RESOLVED");
  }
}

final emergencyProvider = NotifierProvider<EmergencyNotifier, EmergencyData>(() {
  return EmergencyNotifier();
});

final emergencyHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return storage.getEmergencyHistory();
});
