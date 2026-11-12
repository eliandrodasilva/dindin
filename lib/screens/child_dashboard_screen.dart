import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/currency_badge.dart';
import '../widgets/flat_button.dart';
import '../widgets/flat_card.dart';
import '../widgets/flat_snackbar.dart';
import '../widgets/modals/new_goal_modal.dart';

class ChildDashboardScreen extends StatelessWidget {
  const ChildDashboardScreen({
    super.key,
    this.state,
  });

  final AppState? state;

  IconData _getGoalIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('jogo') || lower.contains('videogame')) {
      return Icons.sports_esports_outlined;
    }
    if (lower.contains('passeio') || lower.contains('viagem')) {
      return Icons.flight_takeoff_rounded;
    }
    if (lower.contains('bicicleta') || lower.contains('patins')) {
      return Icons.pedal_bike_rounded;
    }
    if (lower.contains('livro')) {
      return Icons.menu_book_rounded;
    }
    return Icons.savings_outlined;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month';
  }

  @override
  Widget build(BuildContext context) {
    final appState = state ?? AppStateScope.of(context);
    final currentChild = appState.currentUser;
    final childTasks = appState.tasksForChild(currentChild.id);
    final childGoals = appState.goalsForChild(currentChild.id);
    final childTransactions = appState.transactionsForChild(currentChild.id);
    final pendingOrWaitingTasks =
        childTasks.where((t) => !t.isCompleted).length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Card - Modern Fintech Midnight Slate
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusPill),
                            ),
                            child: Text(
                              'OLÁ, ${currentChild.nome.toUpperCase()}! ⭐',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Meu Cofrinho',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.75),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.savings_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${currentChild.saldo.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        size: 15,
                        color: Color(0xFFFBBF24),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cumpra tarefas para ganhar mais moedas!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: Minhas Metas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'MINHAS METAS',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusPill),
                      border: Border.all(
                        color: AppColors.border,
                        width: AppTheme.borderWidth,
                      ),
                    ),
                    child: Text(
                      '${childGoals.length} ativas',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => NewGoalModal.show(
                      context,
                      state: appState,
                      childId: currentChild.id,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            size: 15,
                            color: AppColors.surface,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Nova Meta',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.surface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (childGoals.isEmpty)
            FlatCard(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Nenhuma meta cadastrada ainda.',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 168,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: childGoals.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final goal = childGoals[index];
                  final percent = (goal.progresso * 100).toInt();

                  return SizedBox(
                    width: 236,
                    child: FlatCard(
                      padding: const EdgeInsets.all(16),
                      borderRadius: AppTheme.borderRadius,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceSubtle,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: AppTheme.borderWidth,
                                  ),
                                ),
                                child: Icon(
                                  _getGoalIcon(goal.titulo),
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  goal.titulo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.text,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'R\$ ${goal.valorAtual.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  Text(
                                    'de R\$ ${goal.valorAlvo.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 7,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceSubtle,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: goal.progresso.clamp(0.0, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$percent% concluído',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (goal.isCompleted)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.successSubtle,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(0xFFA7F3D0),
                                      width: AppTheme.borderWidth,
                                    ),
                                  ),
                                  child: const Text(
                                    'CONQUISTADA!',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.successText,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 24),

          // Section: Tarefas do Dia
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TAREFAS DO DIA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.6,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusPill),
                  border: Border.all(
                    color: AppColors.border,
                    width: AppTheme.borderWidth,
                  ),
                ),
                child: Text(
                  '$pendingOrWaitingTasks para fazer',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (childTasks.isEmpty)
            FlatCard(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Nenhuma tarefa para hoje! Bom descanso!',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            )
          else
            for (final task in childTasks)
              FlatCard(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                borderRadius: AppTheme.borderRadius,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: task.isCompleted
                                ? AppColors.successSubtle
                                : (task.isWaitingApproval
                                    ? AppColors.warningSubtle
                                    : AppColors.surfaceSubtle),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: task.isCompleted
                                  ? const Color(0xFFA7F3D0)
                                  : (task.isWaitingApproval
                                      ? const Color(0xFFFDE68A)
                                      : AppColors.border),
                              width: AppTheme.borderWidth,
                            ),
                          ),
                          child: Icon(
                            task.isCompleted
                                ? Icons.check_circle_rounded
                                : (task.isWaitingApproval
                                    ? Icons.schedule_rounded
                                    : Icons.assignment_outlined),
                            color: task.isCompleted
                                ? AppColors.success
                                : (task.isWaitingApproval
                                    ? AppColors.warning
                                    : AppColors.textSecondary),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.titulo,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.text,
                                  letterSpacing: -0.2,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CurrencyBadge.income(
                                    amount: task.recompensa,
                                    fontSize: 12,
                                  ),
                                  const SizedBox(width: 8),
                                  const Flexible(
                                    child: Text(
                                      'de recompensa',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (task.isPending)
                      FlatButton(
                        text: 'Feito!',
                        icon: const Icon(
                          Icons.check_rounded,
                          size: 18,
                        ),
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        fontSize: 15,
                        isExpanded: true,
                        onPressed: () {
                          appState.concluirTarefaPelaCrianca(task.id);
                          FlatSnackBar.show(
                            context,
                            message:
                                'Tarefa "${task.titulo}" enviada para aprovação dos pais! 🚀',
                            type: FlatSnackBarType.info,
                            icon: Icons.hourglass_top_rounded,
                          );
                        },
                      )
                    else if (task.isWaitingApproval)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warningSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFFDE68A),
                            width: AppTheme.borderWidth,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 16,
                              color: AppColors.warningText,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Aguardando aprovação dos pais',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warningText,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFA7F3D0),
                            width: AppTheme.borderWidth,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: AppColors.successText,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Tarefa Concluída e Paga!',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.successText,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          const SizedBox(height: 24),

          // Section: Últimas Transações
          const Text(
            'ÚLTIMAS TRANSAÇÕES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),
          if (childTransactions.isEmpty)
            FlatCard(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Nenhuma transação registrada ainda.',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            )
          else
            for (final tx in childTransactions.take(3))
              FlatCard(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                borderRadius: 12,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: tx.isCredito
                            ? AppColors.successSubtle
                            : AppColors.alertSubtle,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: tx.isCredito
                              ? const Color(0xFFA7F3D0)
                              : const Color(0xFFFECACA),
                          width: AppTheme.borderWidth,
                        ),
                      ),
                      child: Icon(
                        tx.isCredito
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: tx.isCredito
                            ? AppColors.successText
                            : AppColors.alertText,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
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
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(tx.data),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CurrencyBadge(
                      amount: tx.valor,
                      type: tx.isCredito
                          ? CurrencyBadgeType.income
                          : CurrencyBadgeType.expense,
                      fontSize: 13,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
