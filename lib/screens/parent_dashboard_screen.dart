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
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.16),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        child: FloatingActionButton.extended(
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
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
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Gerenciando Filho
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GERENCIANDO FILHO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
                GestureDetector(
                  onTap: () => AddChildModal.show(context, state: appState),
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
                          Icons.person_add_alt_1_rounded,
                          size: 13,
                          color: AppColors.surface,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '+ Filho',
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
            const SizedBox(height: 10),

            // Horizontal Children Chips
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
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: AppTheme.borderWidth,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.face_rounded,
                              size: 18,
                              color: isSelected
                                  ? AppColors.surface
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              child.nome,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isSelected
                                    ? AppColors.surface
                                    : AppColors.text,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CurrencyBadge.neutral(
                              amount: child.saldo,
                              fontSize: 11,
                              backgroundColor: isSelected
                                  ? Colors.white.withValues(alpha: 0.16)
                                  : AppColors.surfaceSubtle,
                              textColor: isSelected
                                  ? AppColors.surface
                                  : AppColors.text,
                              borderColor: isSelected
                                  ? Colors.transparent
                                  : AppColors.border,
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

            // Quick Actions Card
            if (currentChild != null)
              FlatCard(
                backgroundColor: AppColors.surface,
                padding: const EdgeInsets.all(16),
                borderRadius: AppTheme.borderRadius,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Ações Rápidas para ${currentChild.nome}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CurrencyBadge.neutral(
                          amount: currentChild.saldo,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            text: '+5',
                            backgroundColor: AppColors.successSubtle,
                            textColor: AppColors.successText,
                            borderColor: const Color(0xFFA7F3D0),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            borderRadius: 10,
                            fontSize: 14,
                            shadowOffset: Offset.zero,
                            onPressed: () => TransferCoinsModal.show(
                              context,
                              state: appState,
                              targetChild: currentChild,
                              initialAmount: 5.0,
                              initialReason: 'Recompensa extra',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FlatButton(
                            text: '+10',
                            backgroundColor: AppColors.infoSubtle,
                            textColor: AppColors.infoText,
                            borderColor: const Color(0xFFBAE6FD),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            borderRadius: 10,
                            fontSize: 14,
                            shadowOffset: Offset.zero,
                            onPressed: () => TransferCoinsModal.show(
                              context,
                              state: appState,
                              targetChild: currentChild,
                              initialAmount: 10.0,
                              initialReason: 'Mesada extra',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FlatButton(
                            text: '+20',
                            backgroundColor: AppColors.warningSubtle,
                            textColor: AppColors.warningText,
                            borderColor: const Color(0xFFFDE68A),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            borderRadius: 10,
                            fontSize: 14,
                            shadowOffset: Offset.zero,
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
                        size: 16,
                      ),
                      backgroundColor: AppColors.surfaceSubtle,
                      textColor: AppColors.text,
                      borderColor: AppColors.border,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      borderRadius: 10,
                      isExpanded: true,
                      fontSize: 13,
                      shadowOffset: Offset.zero,
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

            // Section: Aprovações Pendentes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'APROVAÇÕES PENDENTES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: waitingApprovalTasks.isEmpty
                        ? AppColors.surfaceSubtle
                        : AppColors.alertSubtle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: waitingApprovalTasks.isEmpty
                          ? AppColors.border
                          : const Color(0xFFFECACA),
                      width: AppTheme.borderWidth,
                    ),
                  ),
                  child: Text(
                    '${waitingApprovalTasks.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: waitingApprovalTasks.isEmpty
                          ? AppColors.textSecondary
                          : AppColors.alertText,
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
                borderRadius: AppTheme.borderRadius,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.successSubtle,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.done_all_rounded,
                          size: 20,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Nenhuma tarefa pendente de aprovação!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
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
                  backgroundColor: AppColors.surface,
                  padding: const EdgeInsets.all(16),
                  borderRadius: AppTheme.borderRadius,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: AppColors.warningSubtle,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.hourglass_top_rounded,
                              color: AppColors.warningText,
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
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.text,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Text(
                                      'Feito por: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceSubtle,
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
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
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
                                Icons.check_rounded,
                                size: 16,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              borderRadius: 8,
                              fontSize: 12,
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
                              backgroundColor: AppColors.surfaceSubtle,
                              textColor: AppColors.alertText,
                              borderColor: const Color(0xFFFECACA),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              borderRadius: 8,
                              fontSize: 13,
                              shadowOffset: Offset.zero,
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
