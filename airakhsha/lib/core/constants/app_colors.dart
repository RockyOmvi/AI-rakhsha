import 'package:flutter/material.dart';

class AppColors {
  // Primary palette from Project.md
  static const Color primary = Color(0xFFFF3B3B);       // Emergency Red
  static const Color primaryDark = Color(0xFFCC2E2E);
  static const Color secondary = Color(0xFF0F172A);      // Navy Blue
  static const Color accent = Color(0xFFFFD700);          // Gold

  // Dark theme surfaces
  static const Color background = Color(0xFF0B1120);
  static const Color surface = Color(0xFF131B2E);
  static const Color surfaceLight = Color(0xFF1A2540);
  static const Color card = Color(0xFF162036);

  // Text
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF3B3B), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0B1120), Color(0xFF131B2E), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A2540), Color(0xFF162036)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // SOS button glow
  static List<BoxShadow> sosGlow(double intensity) => [
    BoxShadow(
      color: primary.withValues(alpha: 0.3 * intensity),
      blurRadius: 30 * intensity,
      spreadRadius: 10 * intensity,
    ),
    BoxShadow(
      color: primary.withValues(alpha: 0.15 * intensity),
      blurRadius: 60 * intensity,
      spreadRadius: 20 * intensity,
    ),
  ];
}
