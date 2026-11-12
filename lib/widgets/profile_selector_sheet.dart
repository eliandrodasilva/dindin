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
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.borderRadiusLarge)),
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
      backgroundColor: isSelected ? AppColors.surfaceSubtle : AppColors.surface,
      borderColor: isSelected ? AppColors.primary : AppColors.border,
      borderWidth: isSelected ? 1.5 : 1.0,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: 12,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: user.isParent ? AppColors.surfaceSubtle : AppColors.successSubtle,
              shape: BoxShape.circle,
              border: Border.all(
                color: user.isParent ? AppColors.border : const Color(0xFFA7F3D0),
                width: AppTheme.borderWidth,
              ),
            ),
            child: Icon(
              user.isParent ? Icons.shield_outlined : Icons.face_rounded,
              color: user.isParent ? AppColors.text : AppColors.successText,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nome,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.isParent
                      ? 'Controle total, tarefas e mesadas'
                      : 'Saldo: R\$ ${user.saldo.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'ATIVO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.surface,
                  letterSpacing: 0.4,
                ),
              ),
            )
          else
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trocar de Perfil',
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
            const SizedBox(height: 14),
            const Text(
              'MODO RESPONSÁVEL',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
                letterSpacing: 0.6,
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
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
                letterSpacing: 0.6,
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
              backgroundColor: AppColors.surfaceSubtle,
              textColor: AppColors.textSecondary,
              shadowOffset: Offset.zero,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
