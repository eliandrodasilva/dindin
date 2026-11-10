import 'package:flutter/material.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  AppState() {
    _users = [
      const User(
        id: 'parent-1',
        nome: 'Carlos (Pai)',
        role: UserRole.parent,
        avatarSeed: 'carlos',
        saldo: 1500.0,
      ),
      const User(
        id: 'child-1',
        nome: 'Lucas',
        role: UserRole.child,
        avatarSeed: 'lucas',
        saldo: 45.0,
      ),
      const User(
        id: 'child-2',
        nome: 'Sofia',
        role: UserRole.child,
        avatarSeed: 'sofia',
        saldo: 30.0,
      ),
    ];

    _currentUser = _users.first;

    _tasks = [
      const Task(
        id: 'task-1',
        titulo: 'Arrumar a cama e quarto',
        recompensa: 5.0,
        status: TaskStatus.completed,
        atribuidaA: 'child-1',
      ),
      const Task(
        id: 'task-2',
        titulo: 'Fazer o dever de casa de matemática',
        recompensa: 10.0,
        status: TaskStatus.waitingApproval,
        atribuidaA: 'child-1',
      ),
      const Task(
        id: 'task-3',
        titulo: 'Guardar os brinquedos',
        recompensa: 5.0,
        status: TaskStatus.pending,
        atribuidaA: 'child-2',
      ),
      const Task(
        id: 'task-4',
        titulo: 'Regar as plantas do quintal',
        recompensa: 8.0,
        status: TaskStatus.pending,
        atribuidaA: 'child-2',
      ),
    ];

    _goals = [
      const Goal(
        id: 'goal-1',
        titulo: 'Jogo de Videogame',
        valorAlvo: 150.0,
        valorAtual: 45.0,
        childId: 'child-1',
      ),
      const Goal(
        id: 'goal-2',
        titulo: 'Patins Coloridos',
        valorAlvo: 120.0,
        valorAtual: 30.0,
        childId: 'child-2',
      ),
    ];

    _transactions = [
      Transaction(
        id: 'tx-1',
        titulo: 'Mesada semanal',
        valor: 20.0,
        data: DateTime.now().subtract(const Duration(days: 3)),
        tipo: TransactionType.credito,
        childId: 'child-1',
      ),
      Transaction(
        id: 'tx-2',
        titulo: 'Tarefa: Arrumar o quarto',
        valor: 5.0,
        data: DateTime.now().subtract(const Duration(days: 1)),
        tipo: TransactionType.credito,
        childId: 'child-1',
      ),
      Transaction(
        id: 'tx-3',
        titulo: 'Mesada semanal',
        valor: 20.0,
        data: DateTime.now().subtract(const Duration(days: 3)),
        tipo: TransactionType.credito,
        childId: 'child-2',
      ),
    ];
  }

  late List<User> _users;
  late User _currentUser;
  late List<Task> _tasks;
  late List<Goal> _goals;
  late List<Transaction> _transactions;

  List<User> get users => List.unmodifiable(_users);
  User get currentUser => _currentUser;
  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Goal> get goals => List.unmodifiable(_goals);
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  List<User> get children => _users.where((user) => user.isChild).toList();
  User? get parent =>
      _users.where((user) => user.isParent).firstOrNull;

  List<Task> tasksForChild(String childId) =>
      _tasks.where((task) => task.atribuidaA == childId).toList();

  List<Goal> goalsForChild(String childId) =>
      _goals.where((goal) => goal.childId == childId).toList();

  List<Transaction> transactionsForChild(String childId) =>
      _transactions.where((tx) => tx.childId == childId).toList();

  void alternarUsuario([String? userId]) {
    if (userId != null) {
      final found = _users.where((u) => u.id == userId).firstOrNull;
      if (found != null) {
        _currentUser = found;
        notifyListeners();
        return;
      }
    }

    final currentIndex = _users.indexWhere((u) => u.id == _currentUser.id);
    final nextIndex = (currentIndex + 1) % _users.length;
    _currentUser = _users[nextIndex];
    notifyListeners();
  }

  void cadastrarFilho({
    required String nome,
    required double saldoInicial,
  }) {
    final newChild = User(
      id: 'child-${DateTime.now().microsecondsSinceEpoch}',
      nome: nome,
      role: UserRole.child,
      avatarSeed: nome.toLowerCase(),
      saldo: saldoInicial,
    );

    _users.add(newChild);

    if (saldoInicial > 0) {
      _transactions.insert(
        0,
        Transaction(
          id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
          titulo: 'Saldo inicial',
          valor: saldoInicial,
          data: DateTime.now(),
          tipo: TransactionType.credito,
          childId: newChild.id,
        ),
      );
    }

    notifyListeners();
  }

  void transferirMoedas(String childId, double valor, {String? motivo}) {
    if (valor <= 0) return;

    final childIndex = _users.indexWhere((u) => u.id == childId);
    if (childIndex == -1) return;

    final parentIndex = _users.indexWhere((u) => u.isParent);
    if (parentIndex != -1) {
      final parentUser = _users[parentIndex];
      _users[parentIndex] = parentUser.copyWith(
        saldo: parentUser.saldo - valor,
      );
      if (_currentUser.id == parentUser.id) {
        _currentUser = _users[parentIndex];
      }
    }

    final childUser = _users[childIndex];
    _users[childIndex] = childUser.copyWith(
      saldo: childUser.saldo + valor,
    );
    if (_currentUser.id == childUser.id) {
      _currentUser = _users[childIndex];
    }

    _transactions.insert(
      0,
      Transaction(
        id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
        titulo: motivo ?? 'Transferência de Mesada',
        valor: valor,
        data: DateTime.now(),
        tipo: TransactionType.credito,
        childId: childId,
      ),
    );

    notifyListeners();
  }

  void criarTarefa({
    required String titulo,
    required double recompensa,
    required String atribuidaA,
  }) {
    final newTask = Task(
      id: 'task-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      recompensa: recompensa,
      status: TaskStatus.pending,
      atribuidaA: atribuidaA,
    );

    _tasks.add(newTask);
    notifyListeners();
  }

  void concluirTarefaPelaCrianca(String taskId) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    if (task.status != TaskStatus.pending) return;

    _tasks[taskIndex] = task.copyWith(
      status: TaskStatus.waitingApproval,
    );

    notifyListeners();
  }

  void aprovarTarefaPeloPai(String taskId) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    if (task.status == TaskStatus.completed) return;

    _tasks[taskIndex] = task.copyWith(
      status: TaskStatus.completed,
    );

    final childIndex = _users.indexWhere((u) => u.id == task.atribuidaA);
    if (childIndex != -1) {
      final childUser = _users[childIndex];
      _users[childIndex] = childUser.copyWith(
        saldo: childUser.saldo + task.recompensa,
      );
      if (_currentUser.id == childUser.id) {
        _currentUser = _users[childIndex];
      }

      _transactions.insert(
        0,
        Transaction(
          id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
          titulo: 'Recompensa: ${task.titulo}',
          valor: task.recompensa,
          data: DateTime.now(),
          tipo: TransactionType.credito,
          childId: task.atribuidaA,
        ),
      );
    }

    notifyListeners();
  }

  void recusarTarefaPeloPai(String taskId) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    if (task.status != TaskStatus.waitingApproval) return;

    _tasks[taskIndex] = task.copyWith(
      status: TaskStatus.pending,
    );

    notifyListeners();
  }

  void adicionarMeta({
    required String titulo,
    required double valorAlvo,
    required String childId,
    double valorAtual = 0.0,
  }) {
    final newGoal = Goal(
      id: 'goal-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      valorAlvo: valorAlvo,
      valorAtual: valorAtual,
      childId: childId,
    );

    _goals.add(newGoal);
    notifyListeners();
  }
}
