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
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final backgroundColor = switch (type) {
      FlatSnackBarType.success => AppColors.success,
      FlatSnackBarType.info => AppColors.primary,
      FlatSnackBarType.alert => AppColors.alert,
    };

    final effectiveIcon = icon ??
        switch (type) {
          FlatSnackBarType.success => Icons.check_circle_rounded,
          FlatSnackBarType.info => Icons.stars_rounded,
          FlatSnackBarType.alert => Icons.error_outline_rounded,
        };

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: AppColors.border,
              width: AppTheme.borderWidth,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.border,
                offset: AppTheme.shadowOffset,
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                effectiveIcon,
                color: AppColors.text,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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
