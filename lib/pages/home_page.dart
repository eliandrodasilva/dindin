import 'package:flutter/material.dart';
import '../screens/child_dashboard_screen.dart';
import '../screens/parent_dashboard_screen.dart';
import '../state/app_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/profile_header_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isParent = state.currentUser.isParent;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.border,
                  width: AppTheme.borderWidth,
                ),
              ),
              child: const Icon(
                Icons.savings_rounded,
                color: AppColors.text,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'DinDin',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: AppColors.text,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeaderBar(state: state),
            Expanded(
              child: isParent
                  ? ParentDashboardScreen(state: state)
                  : ChildDashboardScreen(state: state),
            ),
          ],
        ),
      ),
    );
  }
}
