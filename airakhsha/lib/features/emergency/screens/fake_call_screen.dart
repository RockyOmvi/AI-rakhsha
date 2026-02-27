import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';

class FakeCallScreen extends StatefulWidget {
  final String callerName;
  final String callerNumber;

  const FakeCallScreen({
    super.key,
    this.callerName = 'Dad',
    this.callerNumber = '+91 98765 43210',
  });

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> with SingleTickerProviderStateMixin {
  bool _isCallAccepted = false;
  Timer? _callDurationTimer;
  int _callSeconds = 0;
  late AnimationController _ringController;
  final FlutterRingtonePlayer _ringtonePlayer = FlutterRingtonePlayer();

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Play ringtone — uses device default alarm tone
    _playRingtone();
  }

  Future<void> _playRingtone() async {
    try {
      // Play the device's default incoming call ringtone
      await _ringtonePlayer.playRingtone(
        looping: true,
        volume: 1.0,
        asAlarm: false,
      );
    } catch (e) {
      debugPrint('Ringtone error: $e');
    }
  }

  void _acceptCall() {
    _ringtonePlayer.stop();
    _ringController.stop();
    setState(() => _isCallAccepted = true);
    _callDurationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _callSeconds++);
    });
  }

  void _declineCall() {
    _ringtonePlayer.stop();
    _ringController.stop();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  String get _formattedTime {
    final minutes = (_callSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (_callSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0a0e21), Color(0xFF1a1a2e), Color(0xFF16213e)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Caller avatar with animation
              AnimatedBuilder(
                animation: _ringController,
                builder: (context, child) {
                  return Container(
                    width: 120 + (_isCallAccepted ? 0 : 10 * _ringController.value),
                    height: 120 + (_isCallAccepted ? 0 : 10 * _ringController.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceLight,
                      boxShadow: _isCallAccepted
                          ? []
                          : [
                              BoxShadow(
                                color: AppColors.success.withValues(alpha: 0.2 * _ringController.value),
                                blurRadius: 30 * _ringController.value,
                                spreadRadius: 10 * _ringController.value,
                              ),
                            ],
                    ),
                    child: Center(
                      child: Text(
                        widget.callerName.isNotEmpty ? widget.callerName[0].toUpperCase() : '?',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                widget.callerName,
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                widget.callerNumber,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                _isCallAccepted ? _formattedTime : 'Incoming call...',
                style: TextStyle(
                  color: _isCallAccepted ? AppColors.success : AppColors.textMuted,
                  fontSize: 16,
                ),
              ),
              const Spacer(flex: 3),

              // Call actions
              if (!_isCallAccepted)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CallActionButton(
                        icon: Icons.call_end,
                        color: AppColors.error,
                        label: 'Decline',
                        onTap: _declineCall,
                      ),
                      _CallActionButton(
                        icon: Icons.call,
                        color: AppColors.success,
                        label: 'Accept',
                        onTap: _acceptCall,
                      ),
                    ],
                  ),
                )
              else
                _CallActionButton(
                  icon: Icons.call_end,
                  color: AppColors.error,
                  label: 'End Call',
                  onTap: _declineCall,
                ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ringtonePlayer.stop();
    _ringController.dispose();
    _callDurationTimer?.cancel();
    super.dispose();
  }
}

class _CallActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _CallActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 2),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}
