import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import 'flat_card.dart';

class CofrinhoExtratoCard extends StatelessWidget {
  const CofrinhoExtratoCard({
    super.key,
    required this.transactions,
    this.title = 'Extrato do cofrinho',
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
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          const FlatCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Nenhuma movimentação no cofrinho ainda.',
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
              children: List.generate(transactions.length, (index) {
                final tx = transactions[index];
                final isLast = index == transactions.length - 1;
                final icon = switch (tx.origem) {
                  TransactionSource.mesada => Icons.calendar_today_outlined,
                  TransactionSource.tarefa => Icons.task_alt_outlined,
                  TransactionSource.saldoInicial => Icons.savings_outlined,
                  TransactionSource.outro => Icons.swap_horiz_rounded,
                };

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(icon, size: 20, color: AppColors.text),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.titulo,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.text,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${tx.origem.label} • ${_formatDate(tx.data)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${tx.isCredito ? '+' : '-'} R\$ ${tx.valor.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: tx.isCredito
                                  ? AppColors.text
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
