import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'state/app_state.dart';
import 'state/app_state_scope.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DinDinApp());
}

class DinDinApp extends StatefulWidget {
  const DinDinApp({super.key});

  @override
  State<DinDinApp> createState() => _DinDinAppState();
}

class _DinDinAppState extends State<DinDinApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: MaterialApp(
        title: 'DinDin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const HomePage(),
      ),
    );
  }
}
