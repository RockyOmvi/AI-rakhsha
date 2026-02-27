import 'package:flutter_test/flutter_test.dart';
import 'package:airakhsha/features/contacts/models/contact_model.dart';

void main() {
  test('TrustedContact serialization round-trip', () {
    final contact = TrustedContact(name: 'Dad', phone: '1234567890', relation: 'Father');
    final map = contact.toMap();
    final restored = TrustedContact.fromMap('test-id', map);

    expect(restored.name, 'Dad');
    expect(restored.phone, '1234567890');
    expect(restored.relation, 'Father');
    expect(restored.id, 'test-id');
  });
}
