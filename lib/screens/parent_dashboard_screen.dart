import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/currency_badge.dart';
import '../widgets/flat_button.dart';
import '../widgets/flat_card.dart';
import '../widgets/flat_snackbar.dart';
import '../widgets/modals/add_child_modal.dart';
import '../widgets/modals/create_task_modal.dart';
import '../widgets/modals/transfer_coins_modal.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({
    super.key,
    this.state,
  });

  final AppState? state;

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  String? _selectedChildId;

  @override
  Widget build(BuildContext context) {
    final appState = widget.state ?? AppStateScope.of(context);
    final children = appState.children;

    final activeChildId = _selectedChildId != null &&
            children.any((c) => c.id == _selectedChildId)
        ? _selectedChildId!
        : (children.isNotEmpty ? children.first.id : '');

    final currentChild = children.where((c) => c.id == activeChildId).firstOrNull ??
        (children.isNotEmpty ? children.first : null);

    final waitingApprovalTasks = appState.tasks
        .where((t) => t.status == TaskStatus.waitingApproval)
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: AppColors.border,
              offset: AppTheme.shadowOffset,
              blurRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: FloatingActionButton.extended(
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.text,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: AppColors.border,
              width: AppTheme.borderWidth,
            ),
          ),
          icon: const Icon(Icons.add_task_rounded, size: 22),
          label: const Text(
            'Nova Tarefa',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          onPressed: () => CreateTaskModal.show(
            context,
            state: appState,
            initialChildId: activeChildId.isNotEmpty ? activeChildId : null,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GERENCIANDO FILHO',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.border,
                    letterSpacing: 0.5,
                  ),
                ),
                GestureDetector(
                  onTap: () => AddChildModal.show(context, state: appState),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
                          Icons.person_add_alt_1_rounded,
                          size: 14,
                          color: AppColors.text,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '+ Filho',
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
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...children.map((child) {
                    final isSelected = child.id == activeChildId;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedChildId = child.id;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.border,
                            width: AppTheme.borderWidth,
                          ),
                          boxShadow: isSelected
                              ? const [
                                  BoxShadow(
                                    color: AppColors.border,
                                    offset: AppTheme.shadowOffsetSmall,
                                    blurRadius: 0,
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.face_rounded,
                              size: 20,
                              color: AppColors.text,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              child.nome,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w900
                                    : FontWeight.w700,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CurrencyBadge.neutral(
                              amount: child.saldo,
                              fontSize: 11,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
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
            const SizedBox(height: 16),
            if (currentChild != null)
              FlatCard(
                backgroundColor: AppColors.surface,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ações Rápidas para ${currentChild.nome}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),
                        CurrencyBadge.neutral(
                          amount: currentChild.saldo,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            text: '+5',
                            backgroundColor: const Color(0xFFE8F5E9),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            borderRadius: 10,
                            fontSize: 15,
                            onPressed: () => TransferCoinsModal.show(
                              context,
                              state: appState,
                              targetChild: currentChild,
                              initialAmount: 5.0,
                              initialReason: 'Recompensa extra',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FlatButton(
                            text: '+10',
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            borderRadius: 10,
                            fontSize: 15,
                            onPressed: () => TransferCoinsModal.show(
                              context,
                              state: appState,
                              targetChild: currentChild,
                              initialAmount: 10.0,
                              initialReason: 'Mesada extra',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FlatButton(
                            text: '+20',
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            borderRadius: 10,
                            fontSize: 15,
                            onPressed: () => TransferCoinsModal.show(
                              context,
                              state: appState,
                              targetChild: currentChild,
                              initialAmount: 20.0,
                              initialReason: 'Mesada semanal',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FlatButton(
                      text: 'Enviar Outro Valor',
                      icon: const Icon(
                        Icons.payments_outlined,
                        size: 18,
                        color: AppColors.text,
                      ),
                      backgroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      borderRadius: 10,
                      isExpanded: true,
                      fontSize: 14,
                      onPressed: () => TransferCoinsModal.show(
                        context,
                        state: appState,
                        targetChild: currentChild,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'APROVAÇÕES PENDENTES',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.border,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: waitingApprovalTasks.isEmpty
                        ? AppColors.surface
                        : AppColors.alert,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.border,
                      width: AppTheme.borderWidth,
                    ),
                  ),
                  child: Text(
                    '${waitingApprovalTasks.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: waitingApprovalTasks.isEmpty
                          ? AppColors.text
                          : AppColors.surface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (waitingApprovalTasks.isEmpty)
              FlatCard(
                backgroundColor: AppColors.surface,
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.done_all_rounded,
                        size: 32,
                        color: AppColors.success,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nenhuma tarefa pendente de aprovação!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              for (final task in waitingApprovalTasks)
                FlatCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  backgroundColor: const Color(0xFFFFFBEA),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.border,
                                width: AppTheme.borderWidth,
                              ),
                            ),
                            child: const Icon(
                              Icons.hourglass_top_rounded,
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
                                  task.titulo,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.text,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Feito por: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.text
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppColors.border,
                                          width: AppTheme.borderWidth,
                                        ),
                                      ),
                                      child: Text(
                                        appState.users
                                            .firstWhere(
                                                (u) => u.id == task.atribuidaA)
                                            .nome,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.text,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CurrencyBadge.income(amount: task.recompensa),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: FlatButton(
                              text:
                                  'Aprovar (+${task.recompensa.toInt()} moedas)',
                              backgroundColor: AppColors.success,
                              icon: const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.text,
                                size: 18,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              borderRadius: 8,
                              fontSize: 13,
                              onPressed: () {
                                appState.aprovarTarefaPeloPai(task.id);
                                FlatSnackBar.show(
                                  context,
                                  message:
                                      'Tarefa "${task.titulo}" aprovada! +R\$ ${task.recompensa.toStringAsFixed(2)} creditados!',
                                  type: FlatSnackBarType.success,
                                  icon: Icons.check_circle_rounded,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: FlatButton(
                              text: 'Recusar',
                              backgroundColor: AppColors.surface,
                              textColor: AppColors.alert,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              borderRadius: 8,
                              fontSize: 13,
                              onPressed: () {
                                appState.recusarTarefaPeloPai(task.id);
                                FlatSnackBar.show(
                                  context,
                                  message:
                                      'Tarefa "${task.titulo}" retornada para revisão.',
                                  type: FlatSnackBarType.alert,
                                  icon: Icons.replay_rounded,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
