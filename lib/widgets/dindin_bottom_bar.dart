import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DinDinBottomBarItem {
  const DinDinBottomBarItem({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
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
          ),
          DinDinBottomBarItem(
            label: 'Filhos',
            icon: Icons.people_outline_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Home',
            icon: Icons.home_outlined,
          ),
          DinDinBottomBarItem(
            label: 'Perfil',
            icon: Icons.person_outline_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Config.',
            icon: Icons.settings_outlined,
          ),
        ]
      : const [
          DinDinBottomBarItem(
            label: 'Tarefas',
            icon: Icons.task_alt_outlined,
          ),
          DinDinBottomBarItem(
            label: 'Desejos',
            icon: Icons.star_outline_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Home',
            icon: Icons.home_outlined,
          ),
          DinDinBottomBarItem(
            label: 'Perfil',
            icon: Icons.person_outline_rounded,
          ),
          DinDinBottomBarItem(
            label: 'Config.',
            icon: Icons.settings_outlined,
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
          height: 64,
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surfaceSubtle,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon,
                            color: isSelected
                                ? AppColors.surface
                                : AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
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
                        item.icon,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
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
