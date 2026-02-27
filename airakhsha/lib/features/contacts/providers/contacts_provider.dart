import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../models/contact_model.dart';

final contactsProvider = FutureProvider<List<TrustedContact>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return storage.getTrustedContacts();
});

class ContactsNotifier extends AsyncNotifier<List<TrustedContact>> {
  @override
  Future<List<TrustedContact>> build() {
    final storage = ref.watch(localStorageProvider);
    return storage.getTrustedContacts();
  }

  Future<void> addContact(TrustedContact contact) async {
    final storage = ref.read(localStorageProvider);
    await storage.addTrustedContact(contact);
    ref.invalidateSelf();
  }

  Future<void> removeContact(String id) async {
    final storage = ref.read(localStorageProvider);
    await storage.removeTrustedContact(id);
    ref.invalidateSelf();
  }
}

final contactsNotifierProvider = AsyncNotifierProvider<ContactsNotifier, List<TrustedContact>>(() {
  return ContactsNotifier();
});
