import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dindin/models/models.dart';
import 'package:dindin/screens/parent_dashboard_screen.dart';
import 'package:dindin/state/app_state.dart';
import 'package:dindin/state/app_state_scope.dart';
import 'package:dindin/theme/app_theme.dart';

void main() {
  testWidgets(
      'ParentDashboardScreen renders children chips, quick transfer, approvals, and creates task',
      (tester) async {
    final state = AppState();

    await tester.pumpWidget(
      AppStateScope(
        notifier: state,
        child: MaterialApp(
          theme: AppTheme.theme,
          home: const Scaffold(
            body: ParentDashboardScreen(),
          ),
        ),
      ),
    );

    expect(find.text('GERENCIANDO FILHO'), findsOneWidget);
    expect(find.text('Lucas'), findsWidgets);
    expect(find.text('Sofia'), findsWidgets);
    expect(find.text('+ Filho'), findsOneWidget);

    expect(find.text('Ações Rápidas para Lucas'), findsOneWidget);
    expect(find.text('+5'), findsOneWidget);
    expect(find.text('+10'), findsOneWidget);
    expect(find.text('+20'), findsOneWidget);

    await tester.tap(find.text('Sofia').first);
    await tester.pumpAndSettle();
    expect(find.text('Ações Rápidas para Sofia'), findsOneWidget);

    await tester.tap(find.text('+10'));
    await tester.pumpAndSettle();

    expect(find.text('Enviar Moedas 💰'), findsOneWidget);

    final sofiaBefore =
        state.users.firstWhere((u) => u.id == 'child-2').saldo;

    await tester.tap(find.text('Confirmar Envio'));
    await tester.pumpAndSettle();

    final sofiaAfter =
        state.users.firstWhere((u) => u.id == 'child-2').saldo;
    expect(sofiaAfter, sofiaBefore + 10.0);

    expect(find.text('APROVAÇÕES PENDENTES'), findsOneWidget);
    expect(find.text('Fazer o dever de casa de matemática'), findsOneWidget);

    final lucasBeforeApproval =
        state.users.firstWhere((u) => u.id == 'child-1').saldo;

    await tester.tap(find.text('Aprovar (+10 moedas)'));
    await tester.pumpAndSettle();

    final lucasAfterApproval =
        state.users.firstWhere((u) => u.id == 'child-1').saldo;
    expect(lucasAfterApproval, lucasBeforeApproval + 10.0);
    expect(
      state.tasks
          .firstWhere((t) => t.id == 'task-2')
          .status,
      TaskStatus.completed,
    );

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    expect(find.text('Criar Nova Tarefa 📋'), findsOneWidget);

    final textFields = find.byType(TextField);
    await tester.enterText(textFields.first, 'Limpar a garagem');

    await tester.tap(find.text('Criar Tarefa'));
    await tester.pumpAndSettle();

    expect(
      state.tasks.any((t) => t.titulo == 'Limpar a garagem'),
      isTrue,
    );
  });
}
