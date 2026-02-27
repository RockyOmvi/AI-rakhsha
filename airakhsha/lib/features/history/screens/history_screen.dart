import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../emergency/providers/emergency_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(emergencyHistoryProvider);

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
                    const Icon(Icons.history, color: AppColors.accent, size: 28),
                    SizedBox(width: 10),
                    Text('Alert History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Your past emergency alerts', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: historyAsync.when(
                  data: (history) {
                    if (history.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_user, size: 64, color: AppColors.success.withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            const Text('No emergencies recorded', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                            const SizedBox(height: 8),
                            const Text('Stay safe!', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: history.length,
                      itemBuilder: (context, index) => _HistoryCard(data: history[index]),
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
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _HistoryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isActive = data['status'] == 'ACTIVE';
    final triggeredAt = data['triggeredAt'] as String?;
    String dateStr = 'Unknown time';
    if (triggeredAt != null) {
      try {
        final dt = DateTime.parse(triggeredAt);
        dateStr = '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {}
    }
    final location = data['initialLocation'] as Map<String, dynamic>?;
    final locationStr = location != null
        ? '${(location['latitude'] as num?)?.toStringAsFixed(4)}, ${(location['longitude'] as num?)?.toStringAsFixed(4)}'
        : 'Unknown';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppColors.primary.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isActive ? AppColors.primary : AppColors.success).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isActive ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                color: isActive ? AppColors.primary : AppColors.success,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isActive ? 'ACTIVE' : 'RESOLVED',
                        style: TextStyle(
                          color: isActive ? AppColors.primary : AppColors.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(dateStr, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(locationStr, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
