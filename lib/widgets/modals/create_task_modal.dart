import 'package:flutter/material.dart';
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
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(
          color: AppColors.border,
          width: AppTheme.borderWidth,
        ),
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
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Criar Nova Tarefa 📋',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.text),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Título da tarefa:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.border,
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
              fontWeight: FontWeight.w800,
              color: AppColors.border,
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
              fontWeight: FontWeight.w800,
              color: AppColors.border,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _selectedChildId,
            items: children
                .map(
                  (c) => DropdownMenuItem(
                    value: c.id,
                    child: Text(c.nome),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedChildId = val);
              }
            },
          ),
          const SizedBox(height: 20),
          FlatButton(
            text: 'Criar Tarefa',
            backgroundColor: AppColors.primary,
            icon: const Icon(
              Icons.add_task_rounded,
              color: AppColors.text,
              size: 20,
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
