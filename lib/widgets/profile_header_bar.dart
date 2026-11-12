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
      backgroundColor: AppColors.surface,
      borderColor: AppColors.border,
      borderRadius: AppTheme.borderRadius,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: currentUser.isParent
                  ? AppColors.surfaceSubtle
                  : AppColors.successSubtle,
              shape: BoxShape.circle,
              border: Border.all(
                color: currentUser.isParent
                    ? AppColors.border
                    : const Color(0xFFA7F3D0),
                width: AppTheme.borderWidth,
              ),
            ),
            child: Icon(
              currentUser.isParent
                  ? Icons.shield_outlined
                  : Icons.face_rounded,
              color: currentUser.isParent
                  ? AppColors.text
                  : AppColors.successText,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.border,
                          width: AppTheme.borderWidth,
                        ),
                      ),
                      child: Text(
                        currentUser.isParent
                            ? 'RESPONSÁVEL'
                            : 'MODO FILHO',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                CurrencyBadge.neutral(
                  amount: currentUser.saldo,
                  fontSize: 11,
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
              size: 15,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            fontSize: 13,
            backgroundColor: AppColors.surfaceSubtle,
            textColor: AppColors.text,
            borderColor: AppColors.border,
            borderRadius: 8,
            shadowOffset: Offset.zero,
            onPressed: () => ProfileSelectorSheet.show(context, state),
          ),
        ],
      ),
    );
  }
}
