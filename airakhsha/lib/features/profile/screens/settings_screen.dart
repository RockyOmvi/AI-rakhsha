import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);
    final authState = authAsync.value;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textSecondary, size: 20),
                    onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
                  ),
                  const Icon(Icons.settings, color: AppColors.textSecondary, size: 28),
                  SizedBox(width: 10),
                  Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 24),

              // Profile card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: Text(
                        (authState?.name ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(authState?.name ?? 'User', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 17)),
                          const SizedBox(height: 3),
                          Text(authState?.email ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _SectionHeader(title: 'About'),
              _SettingsTile(icon: Icons.info_outline, title: 'App Version', subtitle: '1.0.0'),
              _SettingsTile(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', onTap: () {}),
              const SizedBox(height: 20),

              // Logout
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: const Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onTap: () => _showLogoutDialog(context, ref),
                ),
              ),
              const SizedBox(height: 40),

              // ── Branding Footer ──
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF8B0000).withValues(alpha: 0.4), width: 2),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF8B0000).withValues(alpha: 0.25), blurRadius: 20, spreadRadius: 2),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF1A1A1A),
                              child: const Icon(Icons.local_florist, color: Color(0xFF8B0000), size: 36),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'AI Raksha',
                      style: TextStyle(
                        color: Color(0xFF8B0000),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Made by Ritika',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        color: AppColors.textMuted.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  const _SettingsTile({required this.icon, required this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: ListTile(
          leading: Icon(icon, color: AppColors.textSecondary),
          title: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)) : null,
          trailing: onTap != null ? const Icon(Icons.chevron_right, color: AppColors.textMuted) : null,
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
