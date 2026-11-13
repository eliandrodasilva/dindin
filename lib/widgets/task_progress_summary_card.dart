import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'flat_card.dart';

class TaskProgressSummaryCard extends StatelessWidget {
  const TaskProgressSummaryCard({
    super.key,
    required this.summary,
    this.title = 'Resumo das tarefas',
  });

  final TaskSummary summary;
  final String title;

  @override
  Widget build(BuildContext context) {
    final avgPercent = (summary.completionAverage * 100).round();
    final dailyPercent = (summary.dailyProgress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        FlatCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Completadas',
                      value: '${summary.completedCount}',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: AppColors.border,
                  ),
                  Expanded(
                    child: _MetricTile(
                      label: 'Abertas',
                      value: '${summary.openCount}',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: AppColors.border,
                  ),
                  Expanded(
                    child: _MetricTile(
                      label: 'Média',
                      value: '$avgPercent%',
                      highlight: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: AppColors.border),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Progressão das tarefas diárias',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${summary.dailyCompleted}/${summary.dailyTotal} ($dailyPercent%)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusPill),
                child: LinearProgressIndicator(
                  value: summary.dailyProgress,
                  minHeight: 6,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: highlight ? AppColors.primary : AppColors.text,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
