import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../flat_button.dart';
import '../flat_snackbar.dart';

class TransferCoinsModal extends StatefulWidget {
  const TransferCoinsModal({
    super.key,
    required this.state,
    this.targetChild,
    this.initialAmount,
    this.initialReason,
  });

  final AppState state;
  final User? targetChild;
  final double? initialAmount;
  final String? initialReason;

  static Future<void> show(
    BuildContext context, {
    required AppState state,
    User? targetChild,
    double? initialAmount,
    String? initialReason,
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
      builder: (context) => TransferCoinsModal(
        state: state,
        targetChild: targetChild,
        initialAmount: initialAmount,
        initialReason: initialReason,
      ),
    );
  }

  @override
  State<TransferCoinsModal> createState() => _TransferCoinsModalState();
}

class _TransferCoinsModalState extends State<TransferCoinsModal> {
  late final TextEditingController _amountController;
  late final TextEditingController _reasonController;
  late String _selectedChildId;

  @override
  void initState() {
    super.initState();
    final children = widget.state.children;
    _selectedChildId = widget.targetChild?.id ??
        (children.isNotEmpty ? children.first.id : '');

    _amountController = TextEditingController(
      text: widget.initialAmount != null
          ? widget.initialAmount!.toStringAsFixed(2)
          : '10.00',
    );
    _reasonController = TextEditingController(
      text: widget.initialReason ?? 'Transferência de Mesada',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
    if (amount <= 0 || _selectedChildId.isEmpty) return;

    final reason = _reasonController.text.trim();
    widget.state.transferirMoedas(
      _selectedChildId,
      amount,
      motivo: reason.isEmpty ? 'Transferência de Mesada' : reason,
    );

    final childName = widget.state.users
        .firstWhere((u) => u.id == _selectedChildId)
        .nome;

    Navigator.pop(context);

    FlatSnackBar.show(
      context,
      message:
          'Enviado +R\$ ${amount.toStringAsFixed(2)} para $childName com sucesso!',
      type: FlatSnackBarType.success,
      icon: Icons.monetization_on_rounded,
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
                'Enviar Moedas 💰',
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
            'Enviar para:',
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
                    child: Text('${c.nome} (Saldo: R\$ ${c.saldo.toStringAsFixed(2)})'),
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
            'Valor (R\$):',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.border,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixText: 'R\$ ',
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Motivo / Descrição:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.border,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              hintText: 'Ex: Recompensa da semana, Tarefa extra...',
            ),
          ),
          const SizedBox(height: 20),
          FlatButton(
            text: 'Confirmar Envio',
            backgroundColor: AppColors.primary,
            icon: const Icon(
              Icons.send_rounded,
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
