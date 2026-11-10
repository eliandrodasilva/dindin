import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dindin/pages/home_page.dart';
import 'package:dindin/screens/child_dashboard_screen.dart';
import 'package:dindin/screens/parent_dashboard_screen.dart';
import 'package:dindin/state/app_state.dart';
import 'package:dindin/state/app_state_scope.dart';
import 'package:dindin/theme/app_theme.dart';
import 'package:dindin/widgets/profile_header_bar.dart';
import 'package:dindin/widgets/profile_selector_sheet.dart';

void main() {
  testWidgets(
      'HomePage renders ParentDashboardScreen for parent and switches to ChildDashboardScreen',
      (tester) async {
    final appState = AppState();

    await tester.pumpWidget(
      AppStateScope(
        notifier: appState,
        child: MaterialApp(
          theme: AppTheme.theme,
          home: const HomePage(),
        ),
      ),
    );

    expect(find.byType(ProfileHeaderBar), findsOneWidget);
    expect(find.byType(ParentDashboardScreen), findsOneWidget);
    expect(find.byType(ChildDashboardScreen), findsNothing);
    expect(find.text('RESPONSÁVEL'), findsWidgets);

    await tester.tap(find.text('Trocar'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileSelectorSheet), findsOneWidget);
    expect(find.text('Trocar de Perfil'), findsOneWidget);
    expect(find.text('MODO FILHO'), findsOneWidget);

    final lucasInSheet = find.descendant(
      of: find.byType(ProfileSelectorSheet),
      matching: find.text('Lucas'),
    );
    expect(lucasInSheet, findsOneWidget);

    await tester.tap(lucasInSheet);
    await tester.pumpAndSettle();

    expect(find.byType(ChildDashboardScreen), findsOneWidget);
    expect(find.byType(ParentDashboardScreen), findsNothing);
    expect(find.text('OLÁ, LUCAS! ⭐'), findsOneWidget);
    expect(find.text('Meu Cofrinho'), findsOneWidget);

    await tester.tap(find.text('Trocar'));
    await tester.pumpAndSettle();

    final parentInSheet = find.descendant(
      of: find.byType(ProfileSelectorSheet),
      matching: find.text('Carlos (Pai)'),
    );
    expect(parentInSheet, findsOneWidget);

    await tester.tap(parentInSheet);
    await tester.pumpAndSettle();

    expect(find.byType(ParentDashboardScreen), findsOneWidget);
    expect(find.byType(ChildDashboardScreen), findsNothing);
  });
}
