import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../flat_button.dart';
import '../flat_snackbar.dart';

class NewGoalModal extends StatefulWidget {
  const NewGoalModal({
    super.key,
    required this.state,
    required this.childId,
  });

  final AppState state;
  final String childId;

  static Future<void> show(
    BuildContext context, {
    required AppState state,
    required String childId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusLarge)),
      ),
      builder: (context) => NewGoalModal(
        state: state,
        childId: childId,
      ),
    );
  }

  @override
  State<NewGoalModal> createState() => _NewGoalModalState();
}

class _NewGoalModalState extends State<NewGoalModal> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    final target =
        double.tryParse(_targetController.text.replaceAll(',', '.')) ?? 0.0;

    if (title.isEmpty || target <= 0) return;

    widget.state.adicionarMeta(
      titulo: title,
      valorAlvo: target,
      childId: widget.childId,
    );

    Navigator.pop(context);

    FlatSnackBar.show(
      context,
      message: 'Nova meta "$title" criada com sucesso!',
      type: FlatSnackBarType.success,
      icon: Icons.savings_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                'Criar Nova Meta 🎯',
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
            'O que você deseja conquistar?',
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
              hintText: 'Ex: Jogo novo, Patins, Passeio...',
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Quantas moedas (R\$) são necessárias?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _targetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixText: 'R\$ ',
              hintText: '100.00',
            ),
          ),
          const SizedBox(height: 20),
          FlatButton(
            text: 'Salvar Meta!',
            backgroundColor: AppColors.primary,
            icon: const Icon(
              Icons.stars_rounded,
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
