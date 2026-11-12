import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'flat_card.dart';

class MonthlyAllowanceCard extends StatelessWidget {
  const MonthlyAllowanceCard({
    super.key,
    required this.entries,
    required this.childName,
  });

  final List<MonthlyAllowanceEntry> entries;
  final String childName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'MESADA POR MÊS • ${childName.toUpperCase()}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 10),
        if (entries.isEmpty)
          const FlatCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Nenhuma mesada registrada ainda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          )
        else
          FlatCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              children: List.generate(entries.length, (index) {
                final entry = entries[index];
                final isLast = index == entries.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.infoSubtle,
                              borderRadius: BorderRadius.circular(
                                  AppTheme.borderRadiusPill),
                            ),
                            child: Text(
                              entry.monthLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.infoText,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'R\$ ${entry.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.borderSubtle,
                      ),
                  ],
                );
              }),
            ),
          ),
      ],
    );
  }
}
