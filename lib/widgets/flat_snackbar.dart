import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum FlatSnackBarType {
  success,
  info,
  alert,
}

abstract final class FlatSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    FlatSnackBarType type = FlatSnackBarType.success,
    IconData? icon,
    Duration duration = const Duration(milliseconds: 2800),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final (accentColor, iconBgColor, defaultIcon) = switch (type) {
      FlatSnackBarType.success => (
          AppColors.success,
          AppColors.successSubtle,
          Icons.check_circle_rounded,
        ),
      FlatSnackBarType.info => (
          AppColors.primaryAccent,
          AppColors.infoSubtle,
          Icons.info_rounded,
        ),
      FlatSnackBarType.alert => (
          AppColors.alert,
          AppColors.alertSubtle,
          Icons.error_outline_rounded,
        ),
    };

    final effectiveIcon = icon ?? defaultIcon;

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        padding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.border,
              width: AppTheme.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  effectiveIcon,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
