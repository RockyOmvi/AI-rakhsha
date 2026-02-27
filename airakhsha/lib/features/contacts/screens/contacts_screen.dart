import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/contacts_provider.dart';
import '../models/contact_model.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsNotifierProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textSecondary, size: 20),
                      onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
                    ),
                    const Icon(Icons.group, color: AppColors.info, size: 28),
                    const SizedBox(width: 10),
                    const Text('Trusted Contacts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const Spacer(),
                    IconButton(
                      icon: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add, color: AppColors.primary, size: 20),
                      ),
                      onPressed: () => _showAddDialog(context, ref),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('People who will be alerted in emergencies', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: contactsAsync.when(
                  data: (contacts) {
                    if (contacts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_add, size: 64, color: AppColors.textMuted.withValues(alpha: 0.4)),
                            const SizedBox(height: 16),
                            const Text('No contacts yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                            const SizedBox(height: 8),
                            const Text('Tap + to add a trusted contact', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return Dismissible(
                          key: ValueKey(contact.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: AppColors.error),
                          ),
                          onDismissed: (_) {
                            if (contact.id != null) {
                              ref.read(contactsNotifierProvider.notifier).removeContact(contact.id!);
                            }
                          },
                          child: _ContactCard(contact: contact),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.error))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final relationC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Contact', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            TextField(controller: phoneC, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone),
            const SizedBox(height: 10),
            TextField(controller: relationC, decoration: const InputDecoration(labelText: 'Relation (e.g. Father)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameC.text.isNotEmpty && phoneC.text.isNotEmpty) {
                ref.read(contactsNotifierProvider.notifier).addContact(
                  TrustedContact(name: nameC.text, phone: phoneC.text, relation: relationC.text),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final TrustedContact contact;
  const _ContactCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.info.withValues(alpha: 0.15),
              child: Text(
                contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                style: const TextStyle(color: AppColors.info, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 3),
                  Text('${contact.phone}  •  ${contact.relation}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: AppColors.textMuted, size: 18),
            const Text('Swipe', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
