import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'flat_button.dart';
import 'flat_card.dart';

class ProfileSelectorSheet extends StatelessWidget {
  const ProfileSelectorSheet({
    super.key,
    required this.state,
  });

  final AppState state;

  static Future<void> show(BuildContext context, AppState state) {
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
      builder: (context) => ProfileSelectorSheet(state: state),
    );
  }

  Widget _buildUserCard({
    required BuildContext context,
    required User user,
    required bool isSelected,
  }) {
    return FlatCard(
      onTap: () {
        state.alternarUsuario(user.id);
        Navigator.pop(context);
      },
      backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: user.isParent ? AppColors.surface : AppColors.success,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
                width: AppTheme.borderWidth,
              ),
            ),
            child: Icon(
              user.isParent ? Icons.shield_rounded : Icons.face_rounded,
              color: AppColors.text,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.isParent
                      ? 'Controle total, tarefas e mesadas'
                      : 'Saldo: R\$ ${user.saldo.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.border,
                  width: AppTheme.borderWidth,
                ),
              ),
              child: const Text(
                'ATIVO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
            )
          else
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.border,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parent = state.parent;
    final children = state.children;
    final currentUserId = state.currentUser.id;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trocar de Perfil',
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
              'MODO RESPONSÁVEL',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.border,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            if (parent != null)
              _buildUserCard(
                context: context,
                user: parent,
                isSelected: parent.id == currentUserId,
              ),
            const SizedBox(height: 8),
            const Text(
              'MODO FILHO',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.border,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            for (final child in children)
              _buildUserCard(
                context: context,
                user: child,
                isSelected: child.id == currentUserId,
              ),
            const SizedBox(height: 12),
            FlatButton(
              text: 'Fechar',
              backgroundColor: AppColors.surface,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
