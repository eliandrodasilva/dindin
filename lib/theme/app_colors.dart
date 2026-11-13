import 'package:flutter/material.dart';

/// Centralized color tokens for the DinDin application.
///
/// Inspired by Nubank's clean fintech visual identity:
/// signature vibrant purple header, pure white canvas, and soft-gray pill cards.
abstract final class AppColors {
  // Neutral Canvas & Surfaces
  static const Color background = Color(0xFFFFFFFF); // Pure crisp white canvas
  static const Color surface = Color(0xFFFFFFFF); // White elevated surface
  static const Color surfaceSubtle = Color(0xFFF0F1F5); // Soft gray pill & card fill
  static const Color border = Color(0xFFE5E7EB); // Subtle hairline divider
  static const Color borderSubtle = Color(0xFFF0F1F5); // Soft inner divider

  // Typography
  static const Color text = Color(0xFF111111); // High-contrast near-black
  static const Color textSecondary = Color(0xFF5E626E); // Muted slate-gray body
  static const Color textMuted = Color(0xFF8C909C); // Subtle hints & timestamps

  // Brand / Primary Action (Signature Purple)
  static const Color primary = Color(0xFF820AD1); // Signature vibrant purple
  static const Color primaryLight = Color(0xFF9C3FE4); // Lighter purple for header avatars
  static const Color primaryAccent = Color(0xFF820AD1); // Unified brand purple accent
  static const Color primarySubtle = Color(0xFFF3E8FF); // Soft lavender tint

  // Semantic Accents
  static const Color success = Color(0xFF16A34A); // Clean emerald green
  static const Color successSubtle = Color(0xFFDCFCE7); // Soft green background
  static const Color successText = Color(0xFF15803D); // Green 700 text

  static const Color alert = Color(0xFFDC2626); // Clean red for logout/cancel
  static const Color alertSubtle = Color(0xFFFEE2E2); // Soft red background
  static const Color alertText = Color(0xFFB91C1C); // Red 700 text

  static const Color warning = Color(0xFFD97706); // Warm amber for pending review
  static const Color warningSubtle = Color(0xFFFEF3C7); // Soft amber background
  static const Color warningText = Color(0xFFB45309); // Amber 700 text

  static const Color info = Color(0xFF820AD1); // Brand purple for info pills
  static const Color infoSubtle = Color(0xFFF3E8FF); // Soft lavender background
  static const Color infoText = Color(0xFF6B21A8); // Deep purple text
}
