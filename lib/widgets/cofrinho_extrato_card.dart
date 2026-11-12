import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'flat_card.dart';

class CofrinhoExtratoCard extends StatelessWidget {
  const CofrinhoExtratoCard({
    super.key,
    required this.transactions,
    this.title = 'Extrato do Cofrinho',
  });

  final List<Transaction> transactions;
  final String title;

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 10),
        if (transactions.isEmpty)
          const FlatCard(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Nenhuma movimentação no cofrinho ainda.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          )
        else
          FlatCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Column(
              children: List.generate(transactions.length, (index) {
                final tx = transactions[index];
                final isLast = index == transactions.length - 1;
                final (badgeBg, badgeFg, icon) = switch (tx.origem) {
                  TransactionSource.mesada => (
                      AppColors.infoSubtle,
                      AppColors.infoText,
                      Icons.calendar_month_rounded,
                    ),
                  TransactionSource.tarefa => (
                      AppColors.successSubtle,
                      AppColors.successText,
                      Icons.task_alt_rounded,
                    ),
                  TransactionSource.saldoInicial => (
                      AppColors.surfaceSubtle,
                      AppColors.textSecondary,
                      Icons.savings_outlined,
                    ),
                  TransactionSource.outro => (
                      AppColors.warningSubtle,
                      AppColors.warningText,
                      Icons.swap_horiz_rounded,
                    ),
                };

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(icon, size: 18, color: badgeFg),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.titulo,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.text,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: badgeBg,
                                        borderRadius: BorderRadius.circular(
                                            AppTheme.borderRadiusPill),
                                      ),
                                      child: Text(
                                        tx.origem.label,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: badgeFg,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _formatDate(tx.data),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${tx.isCredito ? '+' : '-'} R\$ ${tx.valor.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: tx.isCredito
                                  ? AppColors.successText
                                  : AppColors.alertText,
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
