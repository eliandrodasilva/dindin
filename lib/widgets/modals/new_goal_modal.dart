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
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(
          color: AppColors.border,
          width: AppTheme.borderWidth,
        ),
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
      icon: Icons.savings_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                'Criar Nova Meta 🎯',
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
            'O que você deseja conquistar?',
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
              hintText: 'Ex: Jogo novo, Patins, Passeio...',
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Quantas moedas (R\$) são necessárias?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.border,
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
