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

    final showHeader = _currentIndex != 4;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          if (showHeader)
            Container(
              width: double.infinity,
              color: AppColors.primary,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _currentIndex = 3),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.surface,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Olá, ${currentUser.nome}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.surface,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: SafeArea(
              top: !showHeader,
              bottom: false,
              child: body,
            ),
          ),
        ],
      ),
      bottomNavigationBar: DinDinBottomBar(
        isParent: isParent,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
