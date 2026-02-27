import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class SosButton extends StatefulWidget {
  final VoidCallback onTrigger;

  const SosButton({super.key, required this.onTrigger});

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  Timer? _countdownTimer;
  int _countdown = 3;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  void _onPressStart() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isPressed = true;
      _countdown = 3;
    });
    _progressController.forward(from: 0);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPressed) {
        timer.cancel();
        return;
      }
      setState(() => _countdown--);
      HapticFeedback.lightImpact();

      if (_countdown <= 0) {
        timer.cancel();
        HapticFeedback.heavyImpact();
        widget.onTrigger();
        _reset();
      }
    });
  }

  void _onPressEnd() {
    if (_countdown > 0) _reset();
  }

  void _reset() {
    setState(() {
      _isPressed = false;
      _countdown = 3;
    });
    _countdownTimer?.cancel();
    _progressController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _progressController]),
      builder: (context, child) {
        final pulseVal = _pulseController.value;
        final progressVal = _progressController.value;

        return GestureDetector(
          onLongPressStart: (_) => _onPressStart(),
          onLongPressEnd: (_) => _onPressEnd(),
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow rings
                if (!_isPressed) ...[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.12 + 0.12 * pulseVal),
                          blurRadius: 40 + 20 * pulseVal,
                          spreadRadius: 10 + 15 * pulseVal,
                        ),
                      ],
                    ),
                  ),
                ],
                // Progress ring (when pressed)
                if (_isPressed)
                  SizedBox(
                    width: 190,
                    height: 190,
                    child: CircularProgressIndicator(
                      value: progressVal,
                      strokeWidth: 5,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.lerp(AppColors.accent, AppColors.primary, progressVal)!,
                      ),
                    ),
                  ),
                // Core button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isPressed ? 155 : 165,
                  height: _isPressed ? 155 : 165,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _isPressed
                          ? [const Color(0xFFCC2020), const Color(0xFF991818)]
                          : [AppColors.primary, const Color(0xFFE63333)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: _isPressed ? 0.5 : 0.3),
                        blurRadius: _isPressed ? 20 : 15,
                        spreadRadius: _isPressed ? 3 : 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isPressed ? '$_countdown' : 'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _isPressed ? 52 : 44,
                            fontWeight: FontWeight.w900,
                            letterSpacing: _isPressed ? 0 : 4,
                          ),
                        ),
                        if (!_isPressed)
                          Text(
                            'HOLD',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 3,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
