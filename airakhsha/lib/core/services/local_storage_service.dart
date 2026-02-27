import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import '../../features/contacts/models/contact_model.dart';

/// Local storage service using Hive — replaces Firebase Firestore.
/// All data persists on device.
class LocalStorageService {
  static const String _usersBox = 'users';
  static const String _contactsBox = 'contacts';
  static const String _emergenciesBox = 'emergencies';
  static const String _authBox = 'auth';

  // ── Auth ────────────────────────────────────────────────────────

  Future<Box> get _auth async => await Hive.openBox(_authBox);

  Future<void> saveSession(String email, String name, String phone) async {
    final box = await _auth;
    await box.put('email', email);
    await box.put('name', name);
    await box.put('phone', phone);
    await box.put('isLoggedIn', true);
  }

  Future<bool> isLoggedIn() async {
    final box = await _auth;
    return box.get('isLoggedIn', defaultValue: false);
  }

  Future<Map<String, dynamic>?> getSession() async {
    final box = await _auth;
    if (box.get('isLoggedIn', defaultValue: false) != true) return null;
    return {
      'email': box.get('email', defaultValue: ''),
      'name': box.get('name', defaultValue: ''),
      'phone': box.get('phone', defaultValue: ''),
    };
  }

  Future<void> clearSession() async {
    final box = await _auth;
    await box.clear();
  }

  // ── Users (Registration) ───────────────────────────────────────

  Future<bool> registerUser(String name, String email, String password, String phone) async {
    final box = await Hive.openBox(_usersBox);
    // Check if email already taken
    if (box.containsKey(email)) return false;
    await box.put(email, {
      'name': name,
      'email': email,
      'password': password,  // In production, this should be hashed
      'phone': phone,
      'createdAt': DateTime.now().toIso8601String(),
    });
    await saveSession(email, name, phone);
    return true;
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final box = await Hive.openBox(_usersBox);
    final userData = box.get(email);
    if (userData == null) return null;
    final data = Map<String, dynamic>.from(userData);
    if (data['password'] != password) return null;
    await saveSession(email, data['name'] ?? '', data['phone'] ?? '');
    return data;
  }

  Future<void> logout() async {
    await clearSession();
  }

  // ── Trusted Contacts ──────────────────────────────────────────

  Future<Box> get _contacts async => await Hive.openBox(_contactsBox);

  Future<List<TrustedContact>> getTrustedContacts() async {
    final box = await _contacts;
    final List<TrustedContact> contacts = [];
    for (int i = 0; i < box.length; i++) {
      final key = box.keyAt(i).toString();
      final data = Map<String, dynamic>.from(box.getAt(i));
      contacts.add(TrustedContact.fromMap(key, data));
    }
    return contacts;
  }

  Future<void> addTrustedContact(TrustedContact contact) async {
    final box = await _contacts;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await box.put(id, contact.toMap());
  }

  Future<void> removeTrustedContact(String id) async {
    final box = await _contacts;
    await box.delete(id);
  }

  // ── Emergencies ───────────────────────────────────────────────

  Future<Box> get _emergencies async => await Hive.openBox(_emergenciesBox);

  Future<String> logEmergency(double lat, double lng) async {
    final box = await _emergencies;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await box.put(id, {
      'id': id,
      'status': 'ACTIVE',
      'triggeredAt': DateTime.now().toIso8601String(),
      'initialLocation': {'latitude': lat, 'longitude': lng},
      'resolvedAt': null,
    });
    if (kDebugMode) debugPrint('Emergency logged: $id');
    return id;
  }

  Future<void> resolveEmergency(String id) async {
    final box = await _emergencies;
    final data = box.get(id);
    if (data != null) {
      final updated = Map<String, dynamic>.from(data);
      updated['status'] = 'RESOLVED';
      updated['resolvedAt'] = DateTime.now().toIso8601String();
      await box.put(id, updated);
    }
  }

  Future<List<Map<String, dynamic>>> getEmergencyHistory() async {
    final box = await _emergencies;
    final List<Map<String, dynamic>> history = [];
    for (int i = box.length - 1; i >= 0; i--) {
      final data = Map<String, dynamic>.from(box.getAt(i));
      history.add(data);
    }
    return history;
  }
}
