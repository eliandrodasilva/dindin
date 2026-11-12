import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dindin/models/models.dart';
import 'package:dindin/screens/child_dashboard_screen.dart';
import 'package:dindin/state/app_state.dart';
import 'package:dindin/state/app_state_scope.dart';
import 'package:dindin/theme/app_theme.dart';

void main() {
  testWidgets('ChildDashboardScreen renders hero card, goals, tasks, and history',
      (tester) async {
    final state = AppState();
    state.alternarUsuario('child-2');

    await tester.pumpWidget(
      AppStateScope(
        notifier: state,
        child: MaterialApp(
          theme: AppTheme.theme,
          home: const Scaffold(
            body: ChildDashboardScreen(),
          ),
        ),
      ),
    );

    expect(find.text('OLÁ, SOFIA! ⭐'), findsOneWidget);
    expect(find.text('Meu Cofrinho'), findsOneWidget);
    expect(find.text('R\$ 40.00'), findsOneWidget);

    expect(find.text('MINHAS METAS'), findsOneWidget);
    expect(find.text('Patins Coloridos'), findsOneWidget);

    expect(find.text('TAREFAS DO DIA'), findsOneWidget);
    expect(find.text('Limpar e organizar a mesa de estudos'), findsOneWidget);
    expect(find.text('Feito!'), findsWidgets);

    expect(find.text('ÚLTIMAS TRANSAÇÕES'), findsOneWidget);
    expect(find.text('Mesada do mês'), findsOneWidget);

    final feitoButton = find.text('Feito!').first;
    await tester.ensureVisible(feitoButton);
    await tester.tap(feitoButton);
    await tester.pumpAndSettle();

    expect(find.text('Aguardando aprovação dos pais'), findsOneWidget);
    expect(
      state.tasks.firstWhere((t) => t.titulo == 'Limpar e organizar a mesa de estudos').status,
      TaskStatus.waitingApproval,
    );
  });
}
