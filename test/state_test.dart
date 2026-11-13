import 'package:flutter_test/flutter_test.dart';
import 'package:dindin/models/models.dart';
import 'package:dindin/state/app_state.dart';

void main() {
  group('AppState Tests', () {
    late AppState state;

    setUp(() {
      state = AppState();
    });

    test('Initial state contains 1 parent and 2 children', () {
      expect(state.users.length, 3);
      expect(state.parent, isNotNull);
      expect(state.parent!.role, UserRole.parent);
      expect(state.children.length, 2);
      expect(state.currentUser.id, state.parent!.id);
    });

    test('alternarUsuario cycles through users or selects specific user', () {
      final initialId = state.currentUser.id;
      state.alternarUsuario();
      expect(state.currentUser.id, isNot(initialId));

      state.alternarUsuario('child-2');
      expect(state.currentUser.id, 'child-2');
      expect(state.currentUser.nome, 'Sofia');
    });

    test('transferirMoedas transfers balance from parent to child', () {
      final parentBefore = state.parent!.saldo;
      final childBefore =
          state.children.firstWhere((c) => c.id == 'child-1').saldo;

      state.transferirMoedas('child-1', 25.0);

      final parentAfter = state.parent!.saldo;
      final childAfter =
          state.children.firstWhere((c) => c.id == 'child-1').saldo;

      expect(parentAfter, parentBefore - 25.0);
      expect(childAfter, childBefore + 25.0);
      expect(state.transactions.first.childId, 'child-1');
      expect(state.transactions.first.valor, 25.0);
      expect(state.transactions.first.tipo, TransactionType.credito);
    });

    test('criarTarefa adds a new task with pending status', () {
      final initialCount = state.tasks.length;
      state.criarTarefa(
        titulo: 'Lavar a louça',
        recompensa: 7.0,
        atribuidaA: 'child-1',
      );

      expect(state.tasks.length, initialCount + 1);
      final newTask = state.tasks.last;
      expect(newTask.titulo, 'Lavar a louça');
      expect(newTask.recompensa, 7.0);
      expect(newTask.status, TaskStatus.pending);
      expect(newTask.atribuidaA, 'child-1');
    });

    test('concluirTarefaPelaCrianca changes status to waitingApproval', () {
      final pendingTask =
          state.tasks.firstWhere((t) => t.status == TaskStatus.pending);

      state.concluirTarefaPelaCrianca(pendingTask.id);

      final updatedTask =
          state.tasks.firstWhere((t) => t.id == pendingTask.id);
      expect(updatedTask.status, TaskStatus.waitingApproval);
    });

    test('aprovarTarefaPeloPai completes task and rewards child', () {
      final waitingTask =
          state.tasks.firstWhere((t) => t.status == TaskStatus.waitingApproval);
      final childBefore =
          state.users.firstWhere((u) => u.id == waitingTask.atribuidaA).saldo;

      state.aprovarTarefaPeloPai(waitingTask.id);

      final updatedTask =
          state.tasks.firstWhere((t) => t.id == waitingTask.id);
      expect(updatedTask.status, TaskStatus.completed);

      final childAfter =
          state.users.firstWhere((u) => u.id == waitingTask.atribuidaA).saldo;
      expect(childAfter, childBefore + waitingTask.recompensa);
      expect(state.transactions.first.valor, waitingTask.recompensa);
      expect(state.transactions.first.tipo, TransactionType.credito);
    });

    test('adicionarMeta adds new goal for child', () {
      final initialGoals = state.goals.length;
      state.adicionarMeta(
        titulo: 'Bicicleta Nova',
        valorAlvo: 500.0,
        childId: 'child-1',
        valorAtual: 20.0,
      );

      expect(state.goals.length, initialGoals + 1);
      final newGoal = state.goals.last;
      expect(newGoal.titulo, 'Bicicleta Nova');
      expect(newGoal.valorAlvo, 500.0);
      expect(newGoal.valorAtual, 20.0);
      expect(newGoal.childId, 'child-1');
      expect(newGoal.progresso, 20.0 / 500.0);
    });

    test('login and logout toggle isLoggedIn and set currentUser', () {
      expect(state.isLoggedIn, isFalse);

      state.login('child-1');
      expect(state.isLoggedIn, isTrue);
      expect(state.currentUser.id, 'child-1');

      state.logout();
      expect(state.isLoggedIn, isFalse);
    });

    test('criarTarefa supports frequency and cancelarTarefaPeloPai cancels task',
        () {
      state.criarTarefa(
        titulo: 'Organizar mochila',
        recompensa: 6.0,
        atribuidaA: 'child-1',
        frequencia: TaskFrequency.diaria,
      );

      final created = state.tasks.last;
      expect(created.frequencia, TaskFrequency.diaria);
      expect(created.status, TaskStatus.pending);

      state.cancelarTarefaPeloPai(created.id);
      final cancelled = state.tasks.firstWhere((t) => t.id == created.id);
      expect(cancelled.status, TaskStatus.cancelled);
    });

    test('mesadaPorMes aggregates monthly allowance and summaryForTasks calculates daily progress',
        () {
      final monthly = state.mesadaPorMes('child-1');
      expect(monthly.isNotEmpty, isTrue);

      final summary = state.summaryForTasks(state.tasksForChild('child-1'));
      expect(summary.dailyTotal, greaterThanOrEqualTo(2));
      expect(summary.completedCount, greaterThanOrEqualTo(1));
    });

    test('comprarMeta deducts target amount from cofrinho and records debit', () {
      state.adicionarMeta(
        titulo: 'Livro Ilustrado',
        valorAlvo: 50.0,
        childId: 'child-1',
      );
      final goal = state.goals.last;
      final balanceBefore =
          state.users.firstWhere((u) => u.id == 'child-1').saldo;

      state.comprarMeta(goal.id);

      final updatedGoal = state.goals.firstWhere((g) => g.id == goal.id);
      final balanceAfter =
          state.users.firstWhere((u) => u.id == 'child-1').saldo;

      expect(updatedGoal.comprado, isTrue);
      expect(balanceAfter, balanceBefore - 50.0);
      expect(state.transactions.first.tipo, TransactionType.debito);
      expect(state.transactions.first.valor, 50.0);
      expect(state.transactions.first.titulo, 'Compra: Livro Ilustrado');
    });
  });
}
