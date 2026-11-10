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
      return Icons.sports_esports_rounded;
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
    return Icons.savings_rounded;
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlatCard(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.all(20),
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
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.border,
                                width: AppTheme.borderWidth,
                              ),
                            ),
                            child: Text(
                              'OLÁ, ${currentChild.nome.toUpperCase()}! ⭐',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Meu Cofrinho',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.border,
                          width: AppTheme.borderWidth,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.border,
                            offset: AppTheme.shadowOffsetSmall,
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.savings_rounded,
                        color: AppColors.text,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'R\$ ${currentChild.saldo.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.border,
                      width: AppTheme.borderWidth,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 16,
                        color: AppColors.text,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Cumpra tarefas para ganhar mais moedas!',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MINHAS METAS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.border,
                  letterSpacing: 0.5,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.border,
                        width: AppTheme.borderWidth,
                      ),
                    ),
                    child: Text(
                      '${childGoals.length} ativas',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
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
                        border: Border.all(
                          color: AppColors.border,
                          width: AppTheme.borderWidth,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.border,
                            offset: AppTheme.shadowOffsetSmall,
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            size: 16,
                            color: AppColors.text,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Nova Meta',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text.withValues(alpha: 0.6),
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
                    const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final goal = childGoals[index];
                  final percent = (goal.progresso * 100).toInt();

                  return SizedBox(
                    width: 230,
                    child: FlatCard(
                      padding: const EdgeInsets.all(14),
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
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: AppTheme.borderWidth,
                                  ),
                                ),
                                child: Icon(
                                  _getGoalIcon(goal.titulo),
                                  color: AppColors.text,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  goal.titulo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.text,
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
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  Text(
                                    'de R\$ ${goal.valorAlvo.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          AppColors.text.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: AppTheme.borderWidth,
                                  ),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: goal.progresso,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius:
                                          BorderRadius.circular(8),
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
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.text,
                                ),
                              ),
                              if (goal.isCompleted)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.border,
                                      width: AppTheme.borderWidth,
                                    ),
                                  ),
                                  child: const Text(
                                    'CONQUISTADA!',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.text,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TAREFAS DO DIA',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.border,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.border,
                    width: AppTheme.borderWidth,
                  ),
                ),
                child: Text(
                  '$pendingOrWaitingTasks para fazer',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text.withValues(alpha: 0.6),
                  ),
                ),
              ),
            )
          else
            for (final task in childTasks)
              FlatCard(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
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
                                ? AppColors.success
                                : (task.isWaitingApproval
                                    ? const Color(0xFFFFF3CD)
                                    : AppColors.surface),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.border,
                              width: AppTheme.borderWidth,
                            ),
                          ),
                          child: Icon(
                            task.isCompleted
                                ? Icons.check_circle_rounded
                                : (task.isWaitingApproval
                                    ? Icons.hourglass_top_rounded
                                    : Icons.assignment_outlined),
                            color: AppColors.text,
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
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.text,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  CurrencyBadge.income(
                                    amount: task.recompensa,
                                    fontSize: 12,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'de recompensa',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.text
                                          .withValues(alpha: 0.6),
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
                          Icons.check_circle_rounded,
                          color: AppColors.text,
                          size: 20,
                        ),
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        fontSize: 16,
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
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.border,
                            width: AppTheme.borderWidth,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 18,
                              color: AppColors.text,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Aguardando aprovação dos pais',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text,
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
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.border,
                            width: AppTheme.borderWidth,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 18,
                              color: AppColors.text,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Tarefa Concluída e Paga!',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          const SizedBox(height: 24),
          const Text(
            'ÚLTIMAS TRANSAÇÕES',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.border,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          if (childTransactions.isEmpty)
            FlatCard(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Nenhuma transação registrada ainda.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text.withValues(alpha: 0.6),
                  ),
                ),
              ),
            )
          else
            for (final tx in childTransactions.take(3))
              FlatCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: tx.isCredito
                            ? AppColors.success
                            : AppColors.alert,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.border,
                          width: AppTheme.borderWidth,
                        ),
                      ),
                      child: Icon(
                        tx.isCredito
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: AppColors.text,
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
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(tx.data),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  AppColors.text.withValues(alpha: 0.6),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
