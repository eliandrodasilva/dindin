import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/cofrinho_extrato_card.dart';
import '../widgets/flat_button.dart';
import '../widgets/flat_card.dart';
import '../widgets/flat_snackbar.dart';
import '../widgets/modals/new_goal_modal.dart';
import '../widgets/monthly_allowance_card.dart';
import '../widgets/task_progress_summary_card.dart';
import '../widgets/task_type_badge.dart';

class ChildHomeTab extends StatelessWidget {
  const ChildHomeTab({
    super.key,
    required this.state,
  });

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final child = state.currentUser;
    final childTasks = state.tasksForChild(child.id);
    final activeTasks = childTasks.where((t) => t.isActive).toList();
    final summary = state.summaryForTasks(childTasks);
    final transactions = state.transactionsForChild(child.id);
    final monthlyAllowance = state.mesadaPorMes(child.id);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OLÁ, ${child.nome.toUpperCase()}! ⭐',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Meu Cofrinho',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'R\$ ${child.saldo.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                    letterSpacing: -0.6,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 28, thickness: 1, color: AppColors.border),
          const SizedBox(height: 18),
          TaskProgressSummaryCard(
            summary: summary,
            title: 'MINHAS TAREFAS & PROGRESSÃO DIÁRIA',
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tarefas ativas',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                '${activeTasks.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (activeTasks.isEmpty)
            const FlatCard(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'Nenhuma tarefa ativa no momento!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ),
            )
          else
            ...activeTasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ChildTaskCard(task: task, state: state),
              ),
            ),
          const SizedBox(height: 12),
          MonthlyAllowanceCard(
            entries: monthlyAllowance,
            childName: child.nome,
          ),
          const SizedBox(height: 18),
          CofrinhoExtratoCard(transactions: transactions),
        ],
      ),
    );
  }
}

class ChildTasksTab extends StatelessWidget {
  const ChildTasksTab({
    super.key,
    required this.state,
  });

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final childTasks = state.tasksForChild(state.currentUser.id);
    final pending = childTasks.where((t) => t.isPending).toList();
    final waiting = childTasks.where((t) => t.isWaitingApproval).toList();
    final completed = childTasks.where((t) => t.isCompleted).toList();
    final cancelled = childTasks.where((t) => t.isCancelled).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ChildTaskSection(
            title: 'EM AGUARDO (${pending.length})',
            tasks: pending,
            state: state,
            emptyMessage: 'Você não tem tarefas pendentes agora!',
          ),
          const SizedBox(height: 16),
          _ChildTaskSection(
            title: 'AGUARDANDO CONFIRMAÇÃO (${waiting.length})',
            tasks: waiting,
            state: state,
            emptyMessage: 'Nenhuma tarefa aguardando confirmação do responsável.',
          ),
          const SizedBox(height: 16),
          _ChildTaskSection(
            title: 'CONCLUÍDAS (${completed.length})',
            tasks: completed,
            state: state,
            emptyMessage: 'Nenhuma tarefa concluída ainda.',
          ),
          if (cancelled.isNotEmpty) ...[
            const SizedBox(height: 16),
            _ChildTaskSection(
              title: 'CANCELADAS (${cancelled.length})',
              tasks: cancelled,
              state: state,
              emptyMessage: '',
            ),
          ],
        ],
      ),
    );
  }
}

class ChildWishlistTab extends StatelessWidget {
  const ChildWishlistTab({
    super.key,
    required this.state,
  });

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final child = state.currentUser;
    final goals = state.goalsForChild(child.id);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text(
          'Novo Desejo',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        onPressed: () => NewGoalModal.show(
          context,
          state: state,
          childId: child.id,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 92),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Lista de desejos e metas',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            if (goals.isEmpty)
              const FlatCard(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Adicione o que você quer conquistar e acompanhe sua meta!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ...goals.map((goal) {
                final savedAmount =
                    child.saldo > goal.valorAtual ? child.saldo : goal.valorAtual;
                final progress = goal.valorAlvo <= 0
                    ? 0.0
                    : (savedAmount / goal.valorAlvo).clamp(0.0, 1.0);
                final reached = savedAmount >= goal.valorAlvo;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FlatCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: reached
                                    ? AppColors.successSubtle
                                    : AppColors.infoSubtle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                reached
                                    ? Icons.celebration_rounded
                                    : Icons.star_rounded,
                                color: reached
                                    ? AppColors.successText
                                    : AppColors.infoText,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal.titulo,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Meta: R\$ ${goal.valorAlvo.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: reached
                                    ? AppColors.successSubtle
                                    : AppColors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(
                                    AppTheme.borderRadiusPill),
                              ),
                              child: Text(
                                '${(progress * 100).round()}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: reached
                                      ? AppColors.successText
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppTheme.borderRadiusPill),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: AppColors.surfaceSubtle,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              reached
                                  ? AppColors.success
                                  : AppColors.primaryAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          reached
                              ? 'Você já atingiu o valor dessa meta!'
                              : 'Faltam R\$ ${(goal.valorAlvo - savedAmount).toStringAsFixed(2)} no cofrinho',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: reached
                                ? AppColors.successText
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _ChildTaskSection extends StatelessWidget {
  const _ChildTaskSection({
    required this.title,
    required this.tasks,
    required this.state,
    required this.emptyMessage,
  });

  final String title;
  final List<Task> tasks;
  final AppState state;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        if (tasks.isEmpty && emptyMessage.isNotEmpty)
          FlatCard(
            child: Text(
              emptyMessage,
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          )
        else
          ...tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ChildTaskCard(task: task, state: state),
            ),
          ),
      ],
    );
  }
}

class _ChildTaskCard extends StatelessWidget {
  const _ChildTaskCard({
    required this.task,
    required this.state,
  });

  final Task task;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  task.titulo,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: task.isCancelled
                        ? AppColors.textMuted
                        : AppColors.text,
                    decoration:
                        task.isCancelled ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '+ R\$ ${task.recompensa.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TaskTypeBadge(frequencia: task.frequencia),
              Text(
                '• ${task.status.label}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: task.isWaitingApproval
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: task.isWaitingApproval
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (task.isPending) ...[
            const SizedBox(height: 10),
            FlatButton(
              text: 'Marcar como Feita',
              backgroundColor: AppColors.primary,
              fontSize: 13,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              onPressed: () {
                state.concluirTarefaPelaCrianca(task.id);
                FlatSnackBar.show(
                  context,
                  message: 'Tarefa enviada para confirmação do responsável!',
                  type: FlatSnackBarType.info,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
