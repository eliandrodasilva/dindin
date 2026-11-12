import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../flat_button.dart';
import '../flat_snackbar.dart';

class CreateTaskModal extends StatefulWidget {
  const CreateTaskModal({
    super.key,
    required this.state,
    this.initialChildId,
  });

  final AppState state;
  final String? initialChildId;

  static Future<void> show(
    BuildContext context, {
    required AppState state,
    String? initialChildId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusLarge)),
      ),
      builder: (context) => CreateTaskModal(
        state: state,
        initialChildId: initialChildId,
      ),
    );
  }

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final _titleController = TextEditingController();
  final _rewardController = TextEditingController(text: '10.00');
  late String _selectedChildId;
  TaskFrequency _selectedFrequency = TaskFrequency.unica;

  @override
  void initState() {
    super.initState();
    final children = widget.state.children;
    _selectedChildId = widget.initialChildId != null &&
            children.any((c) => c.id == widget.initialChildId)
        ? widget.initialChildId!
        : (children.isNotEmpty ? children.first.id : '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    final reward =
        double.tryParse(_rewardController.text.replaceAll(',', '.')) ?? 0.0;

    if (title.isEmpty || reward <= 0 || _selectedChildId.isEmpty) return;

    widget.state.criarTarefa(
      titulo: title,
      recompensa: reward,
      atribuidaA: _selectedChildId,
      frequencia: _selectedFrequency,
    );

    final childName = widget.state.users
        .firstWhere((u) => u.id == _selectedChildId)
        .nome;

    Navigator.pop(context);

    FlatSnackBar.show(
      context,
      message: 'Tarefa "$title" atribuída para $childName!',
      type: FlatSnackBarType.success,
      icon: Icons.add_task_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.state.children;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Criar Nova Tarefa 📋',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                  letterSpacing: -0.3,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 20),
                onPressed: () => Navigator.pop(context),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Título da tarefa:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Ex: Arrumar a cama, Limpar a mesa...',
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Recompensa (R\$):',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _rewardController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixText: 'R\$ ',
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Atribuir para:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _selectedChildId,
            items: children
                .map(
                  (c) => DropdownMenuItem(
                    value: c.id,
                    child: Text(
                      c.nome,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedChildId = val);
              }
            },
          ),
          const SizedBox(height: 14),
          const Text(
            'Tipo de tarefa:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: TaskFrequency.values.map((freq) {
              final isSelected = _selectedFrequency == freq;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: freq != TaskFrequency.values.last ? 8 : 0,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    onTap: () => setState(() => _selectedFrequency = freq),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceSubtle,
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadius),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        freq.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.surface
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          FlatButton(
            text: 'Criar Tarefa',
            backgroundColor: AppColors.primary,
            icon: const Icon(
              Icons.add_task_rounded,
              size: 18,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            isExpanded: true,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
