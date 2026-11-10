import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'currency_badge.dart';
import 'flat_button.dart';
import 'flat_card.dart';
import 'profile_selector_sheet.dart';

class ProfileHeaderBar extends StatelessWidget {
  const ProfileHeaderBar({
    super.key,
    required this.state,
  });

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final currentUser = state.currentUser;

    return FlatCard(
      backgroundColor:
          currentUser.isParent ? AppColors.surface : const Color(0xFFFFF3CD),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: currentUser.isParent
                  ? AppColors.primary
                  : AppColors.success,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
                width: AppTheme.borderWidth,
              ),
            ),
            child: Icon(
              currentUser.isParent
                  ? Icons.shield_rounded
                  : Icons.face_rounded,
              color: AppColors.text,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: currentUser.isParent
                            ? AppColors.border
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        currentUser.isParent
                            ? 'RESPONSÁVEL'
                            : 'MODO FILHO',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: currentUser.isParent
                              ? AppColors.surface
                              : AppColors.text,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        currentUser.nome,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CurrencyBadge.neutral(
                  amount: currentUser.saldo,
                  fontSize: 12,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FlatButton(
            text: 'Trocar',
            icon: const Icon(
              Icons.swap_horiz_rounded,
              size: 16,
              color: AppColors.text,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            backgroundColor: AppColors.primary,
            borderRadius: 8,
            onPressed: () => ProfileSelectorSheet.show(context, state),
          ),
        ],
      ),
    );
  }
}
