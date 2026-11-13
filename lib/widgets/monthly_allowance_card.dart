import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
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
          'Mesada por mês • $childName',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          const FlatCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Nenhuma mesada registrada ainda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          FlatCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: List.generate(entries.length, (index) {
                final entry = entries[index];
                final isLast = index == entries.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: AppColors.text,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            entry.monthLabel,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'R\$ ${entry.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
                        color: AppColors.border,
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
