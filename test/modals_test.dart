import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dindin/models/models.dart';
import 'package:dindin/state/app_state.dart';
import 'package:dindin/state/app_state_scope.dart';
import 'package:dindin/theme/app_theme.dart';
import 'package:dindin/widgets/widgets.dart';

void main() {
  testWidgets('NewGoalModal creates goal and displays SnackBar feedback',
      (tester) async {
    final state = AppState();

    await tester.pumpWidget(
      AppStateScope(
        notifier: state,
        child: MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => NewGoalModal.show(
                  ctx,
                  state: state,
                  childId: 'child-1',
                ),
                child: const Text('Abrir Meta'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir Meta'));
    await tester.pumpAndSettle();

    expect(find.text('Criar Nova Meta 🎯'), findsOneWidget);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Skate Profissional');
    await tester.enterText(fields.at(1), '200.00');

    await tester.tap(find.text('Salvar Meta!'));
    await tester.pumpAndSettle();

    expect(
      state.goals.any((g) => g.titulo == 'Skate Profissional'),
      isTrue,
    );
    expect(find.text('Nova meta "Skate Profissional" criada com sucesso!'),
        findsOneWidget);
  });

  testWidgets('TransferCoinsModal transfers coins and shows feedback',
      (tester) async {
    final state = AppState();
    final lucasBefore = state.users.firstWhere((u) => u.id == 'child-1').saldo;

    await tester.pumpWidget(
      AppStateScope(
        notifier: state,
        child: MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => TransferCoinsModal.show(
                  ctx,
                  state: state,
                  targetChild: state.users.firstWhere((u) => u.id == 'child-1'),
                  initialAmount: 15.0,
                ),
                child: const Text('Transferir'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Transferir'));
    await tester.pumpAndSettle();

    expect(find.text('Enviar Moedas 💰'), findsOneWidget);

    await tester.tap(find.text('Confirmar Envio'));
    await tester.pumpAndSettle();

    final helenaAfter = state.users.firstWhere((u) => u.id == 'child-1').saldo;
    expect(helenaAfter, lucasBefore + 15.0);
    expect(find.text('Enviado +R\$ 15.00 para Helena com sucesso!'),
        findsOneWidget);
  });

  testWidgets('CreateTaskModal creates task and shows feedback',
      (tester) async {
    final state = AppState();

    await tester.pumpWidget(
      AppStateScope(
        notifier: state,
        child: MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => CreateTaskModal.show(
                  ctx,
                  state: state,
                  initialChildId: 'child-2',
                ),
                child: const Text('Nova Tarefa'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Nova Tarefa'));
    await tester.pumpAndSettle();

    expect(find.text('Criar Nova Tarefa 📋'), findsOneWidget);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Ajudar no jantar');

    await tester.tap(find.text('Criar Tarefa'));
    await tester.pumpAndSettle();

    expect(state.tasks.any((t) => t.titulo == 'Ajudar no jantar'), isTrue);
    expect(find.text('Tarefa "Ajudar no jantar" atribuída para Sofia!'),
        findsOneWidget);
  });

  testWidgets('AddChildModal registers new child and shows feedback',
      (tester) async {
    final state = AppState();
    final countBefore = state.children.length;

    await tester.pumpWidget(
      AppStateScope(
        notifier: state,
        child: MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => AddChildModal.show(
                  ctx,
                  state: state,
                ),
                child: const Text('Cadastrar'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.text('Cadastrar Filho 👶'), findsOneWidget);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Beatriz');
    await tester.enterText(fields.at(1), '50.00');

    await tester.tap(find.text('Cadastrar Filho'));
    await tester.pumpAndSettle();

    expect(state.children.length, countBefore + 1);
    final bia = state.children.firstWhere((c) => c.nome == 'Beatriz');
    expect(bia.saldo, 50.0);
    expect(bia.role, UserRole.child);
    expect(
        find.text('Filho(a) "Beatriz" cadastrado(a) com sucesso!'), findsOneWidget);
  });
}
