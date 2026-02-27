import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/emergency_provider.dart';
import '../widgets/sos_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final emergency = ref.watch(emergencyProvider);
    final isActive = emergency.status == EmergencyState.active;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    const Icon(Icons.shield, color: AppColors.primary, size: 28),
                    const SizedBox(width: 8),
                    const Text(
                      'AI Raksha',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: 0.5),
                    ),
                    const Spacer(),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, color: AppColors.primary, size: 8),
                            SizedBox(width: 6),
                            Text('ACTIVE', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Emergency status banner
              if (isActive) ...[
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.primary),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Emergency Active', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('Location is being shared with contacts', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref.read(emergencyProvider.notifier).resolveEmergency(),
                        child: const Text('STOP', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ],

              // Main SOS area
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isActive ? 'HELP IS ON THE WAY' : 'HOLD FOR EMERGENCY',
                        style: TextStyle(
                          color: isActive ? AppColors.primary : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SosButton(
                        onTrigger: () => ref.read(emergencyProvider.notifier).triggerEmergency(),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        isActive ? 'Streaming location every 5s' : 'Press and hold for 3 seconds',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              // Quick actions
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _QuickAction(icon: Icons.call, label: 'Fake Call', color: AppColors.success, onTap: () => _showFakeCallDialog(context)),
                    _QuickAction(icon: Icons.group, label: 'Contacts', color: AppColors.info, onTap: () => context.push('/contacts')),
                    _QuickAction(icon: Icons.history, label: 'History', color: AppColors.accent, onTap: () => context.push('/history')),
                    _QuickAction(icon: Icons.settings, label: 'Settings', color: AppColors.textSecondary, onTap: () => context.push('/settings')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFakeCallDialog(BuildContext parentContext) {
    final nameController = TextEditingController(text: 'Dad');
    final numberController = TextEditingController(text: '+91 98765 43210');

    showDialog(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Schedule Fake Call', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Caller details:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 12),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Caller Name', prefixIcon: Icon(Icons.person, color: AppColors.textMuted, size: 20))),
              const SizedBox(height: 10),
              TextField(controller: numberController, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone, color: AppColors.textMuted, size: 20)), keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              const Text('Call in:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 8),
              ...[
                _buildDelayTile(ctx, '10 seconds', 10, nameController, numberController),
                _buildDelayTile(ctx, '30 seconds', 30, nameController, numberController),
                _buildDelayTile(ctx, '1 minute', 60, nameController, numberController),
                _buildDelayTile(ctx, '5 minutes', 300, nameController, numberController),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDelayTile(BuildContext dialogCtx, String label, int delaySeconds, TextEditingController nameC, TextEditingController numberC) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.timer, color: AppColors.accent, size: 18),
      ),
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
      onTap: () {
        final callerName = nameC.text.isNotEmpty ? nameC.text : 'Dad';
        final callerNumber = numberC.text.isNotEmpty ? numberC.text : '+91 98765 43210';
        Navigator.pop(dialogCtx);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📞 Fake call from $callerName in $label...'),
            backgroundColor: AppColors.surface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

        // Use HomeScreen's context (this), not the dialog context
        Future.delayed(Duration(seconds: delaySeconds), () {
          if (mounted) {
            context.push('/fake-call?name=${Uri.encodeComponent(callerName)}&number=${Uri.encodeComponent(callerNumber)}');
          }
        });
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
