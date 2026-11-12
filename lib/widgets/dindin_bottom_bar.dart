import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DinDinBottomBarItem {
  const DinDinBottomBarItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class DinDinBottomBar extends StatelessWidget {
  const DinDinBottomBar({
    super.key,
    required this.isParent,
    required this.currentIndex,
    required this.onTap,
  });

  final bool isParent;
  final int currentIndex;
  final ValueChanged<int> onTap;

  List<DinDinBottomBarItem> get _items => isParent
      ? const [
          DinDinBottomBarItem(
            label: 'Tarefas',
            icon: Icons.task_alt_outlined,
            activeIcon: Icons.task_alt_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Filhos',
            icon: Icons.family_restroom_outlined,
            activeIcon: Icons.family_restroom_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Home',
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Perfil',
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Config.',
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
          ),
        ]
      : const [
          DinDinBottomBarItem(
            label: 'Tarefas',
            icon: Icons.task_alt_outlined,
            activeIcon: Icons.task_alt_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Desejos',
            icon: Icons.star_outline_rounded,
            activeIcon: Icons.star_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Home',
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Perfil',
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Config.',
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
          ),
        ];

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;
              final isCenterHome = index == 2;

              if (isCenterHome) {
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.primaryAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isSelected
                                        ? AppColors.primary
                                        : AppColors.primaryAccent)
                                    .withValues(alpha: 0.28),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            color: AppColors.surface,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textMuted,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
