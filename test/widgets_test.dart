import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dindin/screens/child_tabs.dart';
import 'package:dindin/state/app_state.dart';
import 'package:dindin/theme/app_colors.dart';
import 'package:dindin/theme/app_theme.dart';
import 'package:dindin/widgets/widgets.dart';

void main() {
  testWidgets('ThemeData is configured properly', (tester) async {
    final theme = AppTheme.theme;

    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.colorScheme.surface, AppColors.surface);
    expect(theme.appBarTheme.backgroundColor, AppColors.background);
    expect(theme.appBarTheme.elevation, 0);
  });

  testWidgets('FlatCard renders child and responds to onTap', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: FlatCard(
            onTap: () => tapped = true,
            child: const Text('Card Content'),
          ),
        ),
      ),
    );

    expect(find.text('Card Content'), findsOneWidget);
    await tester.tap(find.text('Card Content'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets('FlatButton renders and executes onPressed with tactile tap',
      (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: FlatButton(
            text: 'Click Me',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Click Me'), findsOneWidget);
    await tester.tap(find.text('Click Me'));
    await tester.pumpAndSettle();
    expect(pressed, isTrue);
  });

  testWidgets('CurrencyBadge formats and displays correct values',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: const Scaffold(
          body: Column(
            children: [
              CurrencyBadge.income(amount: 1500.50),
              CurrencyBadge.expense(amount: 320.0),
              CurrencyBadge.neutral(amount: 50.0),
            ],
          ),
        ),
      ),
    );

    expect(find.text('+ R\$ 1.500,50'), findsOneWidget);
    expect(find.text('+ R\$ 320,00'), findsNothing);
    expect(find.text('- R\$ 320,00'), findsOneWidget);
    expect(find.text('R\$ 50,00'), findsOneWidget);
  });

  testWidgets('FlatButton keeps icon centered next to text when expanded',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: FlatButton(
              text: 'Enviar Mesada',
              icon: const Icon(Icons.send_rounded, size: 18),
              isExpanded: true,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    final buttonRect = tester.getRect(find.byType(FlatButton));
    final iconRect = tester.getRect(find.byIcon(Icons.send_rounded));
    final textRect = tester.getRect(find.text('Enviar Mesada'));

    expect(iconRect.left, greaterThan(buttonRect.left));
    expect(iconRect.right, lessThan(buttonRect.right));
    expect(iconRect.top, greaterThanOrEqualTo(buttonRect.top));
    expect(iconRect.bottom, lessThanOrEqualTo(buttonRect.bottom));
    expect((textRect.left - iconRect.right).abs(), lessThanOrEqualTo(12));
  });

  testWidgets('ChildWishlistTab progress bar updates when cofrinho changes',
      (tester) async {
    final state = AppState(initialLoggedIn: true);
    state.login('child-1'); // Helena, saldo 65.0, goal-1 valorAlvo 150.0

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: ChildWishlistTab(state: state),
      ),
    );

    // 65 / 150 = 43%
    expect(find.text('43%'), findsOneWidget);

    // Increase cofrinho by 85.0 -> 150.0 (100%)
    state.transferirMoedas('child-1', 85.0);
    await tester.pumpAndSettle();

    expect(find.text('100%'), findsOneWidget);
    expect(find.text('Confirmar compra'), findsOneWidget);
  });
}
