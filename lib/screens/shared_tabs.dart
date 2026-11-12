import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/flat_button.dart';
import '../widgets/flat_card.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.state,
  });

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final user = state.currentUser;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlatCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: user.isParent
                      ? AppColors.primary
                      : AppColors.primaryAccent,
                  child: Text(
                    user.nome.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.surface,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  user.nome,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusPill),
                  ),
                  child: Text(
                    user.isParent ? 'Responsável' : 'Conta Infantil',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FlatButton(
                  text: 'Sair da conta',
                  backgroundColor: AppColors.alert,
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onPressed: state.logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsBlankTab extends StatelessWidget {
  const SettingsBlankTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand();
  }
}
