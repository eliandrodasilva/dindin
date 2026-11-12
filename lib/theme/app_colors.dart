import 'package:flutter/material.dart';

/// Centralized color tokens for the DinDin application.
///
/// Follows a Modern Fintech / Contemporary Soft-Flat design language
/// with Applesque Minimal influences.
abstract final class AppColors {
  // Neutral Canvas & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Crisp slate-50 canvas
  static const Color surface = Color(0xFFFFFFFF); // Pure white elevated cards
  static const Color surfaceSubtle = Color(0xFFF1F5F9); // Light slate-100 for pills & tags
  static const Color border = Color(0xFFE2E8F0); // Subtle 1px slate-200 border
  static const Color borderSubtle = Color(0xFFF1F5F9); // Soft inner divider border

  // Typography
  static const Color text = Color(0xFF0F172A); // Slate 900 for primary headings & values
  static const Color textSecondary = Color(0xFF475569); // Slate 600 for labels & body
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400 for hints & timestamps

  // Brand / Primary Action
  static const Color primary = Color(0xFF0F172A); // Deep slate Apple-like primary
  static const Color primaryAccent = Color(0xFF2563EB); // Vibrant modern fintech blue

  // Semantic Accents
  static const Color success = Color(0xFF10B981); // Emerald 500 for income & completion
  static const Color successSubtle = Color(0xFFECFDF5); // Emerald 50 soft background
  static const Color successText = Color(0xFF047857); // Emerald 700 text

  static const Color alert = Color(0xFFEF4444); // Red/Rose 500 for expense & decline
  static const Color alertSubtle = Color(0xFFFEF2F2); // Red 50 soft background
  static const Color alertText = Color(0xFFB91C1C); // Red 700 text

  static const Color warning = Color(0xFFF59E0B); // Amber 500 for pending reviews
  static const Color warningSubtle = Color(0xFFFFFBEB); // Amber 50 soft background
  static const Color warningText = Color(0xFFB45309); // Amber 700 text

  static const Color info = Color(0xFF3B82F6); // Blue 500 for information
  static const Color infoSubtle = Color(0xFFEFF6FF); // Blue 50 soft background
  static const Color infoText = Color(0xFF1D4ED8); // Blue 700 text
}
