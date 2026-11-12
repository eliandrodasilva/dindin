import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class TaskTypeBadge extends StatelessWidget {
  const TaskTypeBadge({
    super.key,
    required this.frequencia,
  });

  final TaskFrequency frequencia;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon) = switch (frequencia) {
      TaskFrequency.unica => (
          AppColors.surfaceSubtle,
          AppColors.textSecondary,
          Icons.looks_one_outlined,
        ),
      TaskFrequency.diaria => (
          AppColors.infoSubtle,
          AppColors.infoText,
          Icons.repeat_rounded,
        ),
      TaskFrequency.semanal => (
          AppColors.warningSubtle,
          AppColors.warningText,
          Icons.date_range_rounded,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            frequencia.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
