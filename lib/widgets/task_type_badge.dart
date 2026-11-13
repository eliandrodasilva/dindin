import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';

/// Displays task frequency as clean inline metadata rather than a decorative pill.
class TaskTypeBadge extends StatelessWidget {
  const TaskTypeBadge({
    super.key,
    required this.frequencia,
  });

  final TaskFrequency frequencia;

  @override
  Widget build(BuildContext context) {
    return Text(
      frequencia.label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: frequencia == TaskFrequency.unica
            ? AppColors.textSecondary
            : AppColors.primary,
      ),
    );
  }
}
