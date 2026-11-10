import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../flat_button.dart';
import '../flat_snackbar.dart';

class AddChildModal extends StatefulWidget {
  const AddChildModal({
    super.key,
    required this.state,
  });

  final AppState state;

  static Future<void> show(
    BuildContext context, {
    required AppState state,
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
      builder: (context) => AddChildModal(state: state),
    );
  }

  @override
  State<AddChildModal> createState() => _AddChildModalState();
}

class _AddChildModalState extends State<AddChildModal> {
  final _nameController = TextEditingController();
  final _initialBalanceController = TextEditingController(text: '0.00');

  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    final initialBalance =
        double.tryParse(_initialBalanceController.text.replaceAll(',', '.')) ??
            0.0;

    if (name.isEmpty) return;

    widget.state.cadastrarFilho(
      nome: name,
      saldoInicial: initialBalance,
    );

    Navigator.pop(context);

    FlatSnackBar.show(
      context,
      message: 'Filho(a) "$name" cadastrado(a) com sucesso!',
      type: FlatSnackBarType.success,
      icon: Icons.face_rounded,
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
                'Cadastrar Filho 👶',
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
            'Nome do dependente:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.border,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Ex: Arthur, Bia, Enzo...',
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Saldo inicial de moedas (R\$):',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.border,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _initialBalanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixText: 'R\$ ',
            ),
          ),
          const SizedBox(height: 20),
          FlatButton(
            text: 'Cadastrar Filho',
            backgroundColor: AppColors.primary,
            icon: const Icon(
              Icons.person_add_alt_1_rounded,
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
