import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'screens/login_screen.dart';
import 'state/app_state.dart';
import 'state/app_state_scope.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DinDinApp());
}

class DinDinApp extends StatefulWidget {
  const DinDinApp({
    super.key,
    this.initialState,
  });

  final AppState? initialState;

  @override
  State<DinDinApp> createState() => _DinDinAppState();
}

class _DinDinAppState extends State<DinDinApp> {
  late final AppState _appState;
  late final bool _ownsState;

  @override
  void initState() {
    super.initState();
    _ownsState = widget.initialState == null;
    _appState = widget.initialState ?? AppState();
  }

  @override
  void dispose() {
    if (_ownsState) {
      _appState.dispose();
    }
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
        home: AnimatedBuilder(
          animation: _appState,
          builder: (context, _) {
            return _appState.isLoggedIn
                ? const HomePage()
                : LoginScreen(state: _appState);
          },
        ),
      ),
    );
  }
}
