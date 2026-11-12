import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/flat_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, this.state});

  final AppState? state;

  @override
  Widget build(BuildContext context) {
    final appState = state ?? AppStateScope.of(context);
    final parentUser = appState.parent;
    final childUsers = appState.children;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.16),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.savings_rounded,
                    color: AppColors.surface,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'DinDin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 6),
              const SizedBox(height: 28),
              if (parentUser != null) ...[
                const Text(
                  'CONTA DO RESPONSÁVEL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                _MockAccountCard(
                  user: parentUser,
                  subtitle: '',
                  badgeLabel: 'Responsável',
                  badgeBg: AppColors.primary,
                  badgeFg: AppColors.surface,
                  onTap: () => appState.login(parentUser.id),
                ),
                const SizedBox(height: 22),
              ],
              const Text(
                'CONTAS DAS FILHAS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 10),
              ...childUsers.map(
                (child) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MockAccountCard(
                    user: child,
                    subtitle: child.idade != null
                        ? '${child.idade} anos • Cofrinho R\$ ${child.saldo.toStringAsFixed(2)}'
                        : 'Cofrinho R\$ ${child.saldo.toStringAsFixed(2)}',
                    badgeLabel: 'Filha',
                    badgeBg: AppColors.infoSubtle,
                    badgeFg: AppColors.infoText,
                    onTap: () => appState.login(child.id),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FlatCard(
                backgroundColor: AppColors.surfaceSubtle,
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: const [
                    Icon(
                      Icons.shield_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Contas infantis só podem ser criadas a partir da conta do responsável.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockAccountCard extends StatelessWidget {
  const _MockAccountCard({
    required this.user,
    required this.subtitle,
    required this.badgeLabel,
    required this.badgeBg,
    required this.badgeFg,
    required this.onTap,
  });

  final User user;
  final String subtitle;
  final String badgeLabel;
  final Color badgeBg;
  final Color badgeFg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FlatCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: user.isParent
                ? AppColors.primary
                : AppColors.primaryAccent,
            child: Text(
              user.nome.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.surface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.nome,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusPill,
                        ),
                      ),
                      child: Text(
                        badgeLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: badgeFg,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}
