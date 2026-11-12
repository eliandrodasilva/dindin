import 'package:flutter/material.dart';
import '../screens/child_tabs.dart';
import '../screens/parent_tabs.dart';
import '../screens/shared_tabs.dart';
import '../state/app_state_scope.dart';
import '../theme/app_colors.dart';
import '../widgets/dindin_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.initialTabIndex = 2,
  });

  final int initialTabIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;
  String? _lastUserId;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final currentUser = state.currentUser;
    final isParent = currentUser.isParent;

    if (_lastUserId != null && _lastUserId != currentUser.id) {
      _currentIndex = 2;
    }
    _lastUserId = currentUser.id;

    final body = isParent
        ? switch (_currentIndex) {
            0 => ParentTasksTab(state: state),
            1 => ParentChildrenTab(state: state),
            2 => ParentHomeTab(state: state),
            3 => ProfileTab(state: state),
            _ => const SettingsBlankTab(),
          }
        : switch (_currentIndex) {
            0 => ChildTasksTab(state: state),
            1 => ChildWishlistTab(state: state),
            2 => ChildHomeTab(state: state),
            3 => ProfileTab(state: state),
            _ => const SettingsBlankTab(),
          };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _currentIndex == 4
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.savings_rounded,
                      color: AppColors.surface,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Text(
                    'DinDin',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColors.text,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),
      body: SafeArea(child: body),
      bottomNavigationBar: DinDinBottomBar(
        isParent: isParent,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
