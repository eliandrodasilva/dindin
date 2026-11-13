import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/cofrinho_extrato_card.dart';
import '../widgets/currency_badge.dart';
import '../widgets/flat_button.dart';
import '../widgets/flat_card.dart';
import '../widgets/flat_snackbar.dart';
import '../widgets/modals/add_child_modal.dart';
import '../widgets/modals/create_task_modal.dart';
import '../widgets/modals/transfer_coins_modal.dart';
import '../widgets/monthly_allowance_card.dart';
import '../widgets/task_progress_summary_card.dart';
import '../widgets/task_type_badge.dart';

class ParentHomeTab extends StatelessWidget {
  const ParentHomeTab({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final children = state.children;
    final allTasks = state.tasks;
    final activeTasks = allTasks.where((t) => t.isActive).toList();
    final summary = state.summaryForTasks(allTasks);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Filhos conectados',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          if (children.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Nenhum filho conectado.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            FlatCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: List.generate(children.length, (index) {
                  final child = children[index];
                  final isLast = index == children.length - 1;
                  final childActiveCount = state
                      .tasksForChild(child.id)
                      .where((t) => t.isActive)
                      .length;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_outline_rounded,
                              size: 20,
                              color: AppColors.text,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    child.nome,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  Text(
                                    '$childActiveCount ${childActiveCount == 1 ? 'tarefa ativa' : 'tarefas ativas'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'R\$ ${child.saldo.toStringAsFixed(2)}',
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
          const SizedBox(height: 20),
          TaskProgressSummaryCard(summary: summary),
          const SizedBox(height: 20),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (activeTasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'Nenhuma tarefa ativa no momento.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            )
          else
            Column(
              children: List.generate(activeTasks.length, (index) {
                final task = activeTasks[index];
                final isLast = index == activeTasks.length - 1;
                final child = state.users
                    .where((u) => u.id == task.atribuidaA)
                    .firstOrNull;
                return Column(
                  children: [
                    _ParentTaskCard(
                      task: task,
                      childName: child?.nome ?? 'Filha',
                      state: state,
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
        ],
      ),
    );
  }
}

class ParentTasksTab extends StatefulWidget {
  const ParentTasksTab({super.key, required this.state});

  final AppState state;

  @override
  State<ParentTasksTab> createState() => _ParentTasksTabState();
}

class _ParentTasksTabState extends State<ParentTasksTab> {
  String? _filterChildId;

  @override
  Widget build(BuildContext context) {
    final children = widget.state.children;
    final tasks = _filterChildId == null
        ? widget.state.tasks
        : widget.state.tasksForChild(_filterChildId!);

    final waitingApproval = tasks.where((t) => t.isWaitingApproval).toList();
    final pending = tasks.where((t) => t.isPending).toList();
    final completed = tasks.where((t) => t.isCompleted).toList();
    final cancelled = tasks.where((t) => t.isCancelled).toList();

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
        icon: const Icon(Icons.add_task_rounded, size: 20),
        label: const Text(
          'Nova Tarefa',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        onPressed: () => CreateTaskModal.show(
          context,
          state: widget.state,
          initialChildId: _filterChildId,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 92),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Todas',
                    selected: _filterChildId == null,
                    onTap: () => setState(() => _filterChildId = null),
                  ),
                  ...children.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: c.nome,
                        selected: _filterChildId == c.id,
                        onTap: () => setState(() => _filterChildId = c.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _TaskSection(
              title: 'AGUARDANDO CONFIRMAÇÃO (${waitingApproval.length})',
              tasks: waitingApproval,
              state: widget.state,
              emptyMessage: 'Nenhuma tarefa aguardando confirmação.',
            ),
            const SizedBox(height: 16),
            _TaskSection(
              title: 'EM AGUARDO (${pending.length})',
              tasks: pending,
              state: widget.state,
              emptyMessage: 'Nenhuma tarefa em aguardo.',
            ),
            const SizedBox(height: 16),
            _TaskSection(
              title: 'CONCLUÍDAS (${completed.length})',
              tasks: completed,
              state: widget.state,
              emptyMessage: 'Nenhuma tarefa concluída ainda.',
            ),
            if (cancelled.isNotEmpty) ...[
              const SizedBox(height: 16),
              _TaskSection(
                title: 'CANCELADAS (${cancelled.length})',
                tasks: cancelled,
                state: widget.state,
                emptyMessage: '',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ParentChildrenTab extends StatefulWidget {
  const ParentChildrenTab({super.key, required this.state});

  final AppState state;

  @override
  State<ParentChildrenTab> createState() => _ParentChildrenTabState();
}

class _ParentChildrenTabState extends State<ParentChildrenTab> {
  String? _selectedChildId;

  @override
  Widget build(BuildContext context) {
    final children = widget.state.children;
    final activeChildId =
        _selectedChildId != null &&
            children.any((c) => c.id == _selectedChildId)
        ? _selectedChildId!
        : (children.isNotEmpty ? children.first.id : '');

    final selectedChild = children
        .where((c) => c.id == activeChildId)
        .firstOrNull;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'FILHOS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.6,
                ),
              ),
              TextButton.icon(
                onPressed: () =>
                    AddChildModal.show(context, state: widget.state),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                label: const Text(
                  'Adicionar Filho',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (children.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: children.map((child) {
                  final isSelected = child.id == activeChildId;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(
                      label: child.nome,
                      selected: isSelected,
                      onTap: () => setState(() => _selectedChildId = child.id),
                    ),
                  );
                }).toList(),
              ),
            ),
          if (selectedChild != null) ...[
            const SizedBox(height: 16),
            FlatCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cofrinho de ${selectedChild.nome}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text,
                              ),
                            ),
                            if (selectedChild.idade != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${selectedChild.idade} anos',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      CurrencyBadge(amount: selectedChild.saldo),
                    ],
                  ),
                  const SizedBox(height: 14),
                  FlatButton(
                    text: 'Enviar Mesada',
                    backgroundColor: AppColors.primary,
                    icon: const Icon(Icons.send_rounded, size: 17),
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    onPressed: () => TransferCoinsModal.show(
                      context,
                      state: widget.state,
                      targetChild: selectedChild,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            MonthlyAllowanceCard(
              entries: widget.state.mesadaPorMes(selectedChild.id),
              childName: selectedChild.nome,
            ),
            const SizedBox(height: 18),
            CofrinhoExtratoCard(
              transactions: widget.state.transactionsForChild(selectedChild.id),
              title: 'Extrato do cofrinho • ${selectedChild.nome}',
            ),
          ],
        ],
      ),
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({
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
          ...tasks.map((task) {
            final child = state.users
                .where((u) => u.id == task.atribuidaA)
                .firstOrNull;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ParentTaskCard(
                task: task,
                childName: child?.nome ?? 'Filha',
                state: state,
              ),
            );
          }),
      ],
    );
  }
}

class _ParentTaskCard extends StatelessWidget {
  const _ParentTaskCard({
    required this.task,
    required this.childName,
    required this.state,
  });

  final Task task;
  final String childName;
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
                '• $childName • ${task.status.label}',
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
          if (task.isWaitingApproval || task.isPending) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (task.isWaitingApproval) ...[
                  FlatButton(
                    text: 'Aprovar',
                    backgroundColor: AppColors.primary,
                    fontSize: 13,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    onPressed: () {
                      state.aprovarTarefaPeloPai(task.id);
                      FlatSnackBar.show(
                        context,
                        message:
                            'Tarefa aprovada! +R\$ ${task.recompensa.toStringAsFixed(2)} no cofrinho de $childName.',
                        type: FlatSnackBarType.success,
                      );
                    },
                  ),
                  FlatButton(
                    text: 'Recusar',
                    backgroundColor: AppColors.surfaceSubtle,
                    textColor: AppColors.text,
                    fontSize: 13,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    onPressed: () => state.recusarTarefaPeloPai(task.id),
                  ),
                ],
                FlatButton(
                  text: 'Cancelar',
                  backgroundColor: AppColors.alertSubtle,
                  textColor: AppColors.alertText,
                  fontSize: 13,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  onPressed: () {
                    state.cancelarTarefaPeloPai(task.id);
                    FlatSnackBar.show(
                      context,
                      message: 'Tarefa "${task.titulo}" cancelada.',
                      type: FlatSnackBarType.info,
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusPill),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.surface : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
