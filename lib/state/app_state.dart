import 'package:flutter/material.dart';
import '../models/models.dart';

class TaskSummary {
  const TaskSummary({
    required this.completedCount,
    required this.openCount,
    required this.dailyTotal,
    required this.dailyCompleted,
  });

  final int completedCount;
  final int openCount;
  final int dailyTotal;
  final int dailyCompleted;

  int get totalRelevant => completedCount + openCount;

  /// Completion average between completed and open tasks (0.0 to 1.0).
  double get completionAverage =>
      totalRelevant == 0 ? 0.0 : completedCount / totalRelevant;

  /// Daily tasks progression (0.0 to 1.0).
  double get dailyProgress =>
      dailyTotal == 0 ? 0.0 : dailyCompleted / dailyTotal;
}

class MonthlyAllowanceEntry {
  const MonthlyAllowanceEntry({
    required this.monthKey,
    required this.monthLabel,
    required this.total,
  });

  final String monthKey;
  final String monthLabel;
  final double total;
}

class AppState extends ChangeNotifier {
  AppState({bool initialLoggedIn = false}) : _isLoggedIn = initialLoggedIn {
    final now = DateTime.now();
    final previousMonth = DateTime(now.year, now.month - 1, 15);

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
        nome: 'Helena',
        role: UserRole.child,
        avatarSeed: 'helena',
        saldo: 65.0,
        idade: 11,
      ),
      const User(
        id: 'child-2',
        nome: 'Sofia',
        role: UserRole.child,
        avatarSeed: 'sofia',
        saldo: 40.0,
        idade: 9,
      ),
    ];

    _currentUser = _users.first;

    _tasks = [
      const Task(
        id: 'task-1',
        titulo: 'Lavar e secar a louça do almoço',
        recompensa: 5.0,
        status: TaskStatus.completed,
        atribuidaA: 'child-1',
        frequencia: TaskFrequency.diaria,
      ),
      const Task(
        id: 'task-2',
        titulo: 'Organizar a estante de livros e cadernos',
        recompensa: 10.0,
        status: TaskStatus.waitingApproval,
        atribuidaA: 'child-1',
        frequencia: TaskFrequency.unica,
      ),
      const Task(
        id: 'task-3',
        titulo: 'Passear e alimentar o cachorro',
        recompensa: 4.0,
        status: TaskStatus.pending,
        atribuidaA: 'child-1',
        frequencia: TaskFrequency.diaria,
      ),
      const Task(
        id: 'task-4',
        titulo: 'Recolher e dobrar as roupas do varal',
        recompensa: 5.0,
        status: TaskStatus.completed,
        atribuidaA: 'child-2',
        frequencia: TaskFrequency.diaria,
      ),
      const Task(
        id: 'task-5',
        titulo: 'Limpar e organizar a mesa de estudos',
        recompensa: 8.0,
        status: TaskStatus.pending,
        atribuidaA: 'child-2',
        frequencia: TaskFrequency.semanal,
      ),
      const Task(
        id: 'task-6',
        titulo: 'Ler 20 páginas de um livro e fazer resumo',
        recompensa: 6.0,
        status: TaskStatus.pending,
        atribuidaA: 'child-2',
        frequencia: TaskFrequency.diaria,
      ),
    ];

    _goals = [
      const Goal(
        id: 'goal-1',
        titulo: 'Fone de Ouvido Bluetooth',
        valorAlvo: 150.0,
        valorAtual: 65.0,
        childId: 'child-1',
      ),
      const Goal(
        id: 'goal-2',
        titulo: 'Patins Coloridos',
        valorAlvo: 120.0,
        valorAtual: 40.0,
        childId: 'child-2',
      ),
    ];

    _transactions = [
      Transaction(
        id: 'tx-1',
        titulo: 'Mesada do mês',
        valor: 40.0,
        data: now.subtract(const Duration(days: 2)),
        tipo: TransactionType.credito,
        childId: 'child-1',
        origem: TransactionSource.mesada,
      ),
      Transaction(
        id: 'tx-2',
        titulo: 'Recompensa: Lavar e secar a louça do almoço',
        valor: 5.0,
        data: now.subtract(const Duration(days: 1)),
        tipo: TransactionType.credito,
        childId: 'child-1',
        origem: TransactionSource.tarefa,
      ),
      Transaction(
        id: 'tx-3',
        titulo: 'Mesada do mês anterior',
        valor: 40.0,
        data: previousMonth,
        tipo: TransactionType.credito,
        childId: 'child-1',
        origem: TransactionSource.mesada,
      ),
      Transaction(
        id: 'tx-4',
        titulo: 'Mesada do mês',
        valor: 35.0,
        data: now.subtract(const Duration(days: 3)),
        tipo: TransactionType.credito,
        childId: 'child-2',
        origem: TransactionSource.mesada,
      ),
      Transaction(
        id: 'tx-5',
        titulo: 'Recompensa: Recolher e dobrar as roupas do varal',
        valor: 5.0,
        data: now.subtract(const Duration(days: 1)),
        tipo: TransactionType.credito,
        childId: 'child-2',
        origem: TransactionSource.tarefa,
      ),
      Transaction(
        id: 'tx-6',
        titulo: 'Mesada do mês anterior',
        valor: 30.0,
        data: previousMonth,
        tipo: TransactionType.credito,
        childId: 'child-2',
        origem: TransactionSource.mesada,
      ),
    ];
  }

  bool _isLoggedIn;
  late List<User> _users;
  late User _currentUser;
  late List<Task> _tasks;
  late List<Goal> _goals;
  late List<Transaction> _transactions;

  bool get isLoggedIn => _isLoggedIn;
  List<User> get users => List.unmodifiable(_users);
  User get currentUser => _currentUser;
  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Goal> get goals => List.unmodifiable(_goals);
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  List<User> get children => _users.where((user) => user.isChild).toList();
  User? get parent => _users.where((user) => user.isParent).firstOrNull;

  List<Task> tasksForChild(String childId) =>
      _tasks.where((task) => task.atribuidaA == childId).toList();

  List<Goal> goalsForChild(String childId) =>
      _goals.where((goal) => goal.childId == childId).toList();

  List<Transaction> transactionsForChild(String childId) =>
      _transactions.where((tx) => tx.childId == childId).toList();

  TaskSummary summaryForTasks(Iterable<Task> taskList) {
    int completed = 0;
    int open = 0;
    int dailyTotal = 0;
    int dailyCompleted = 0;

    for (final task in taskList) {
      if (task.isCancelled) continue;
      if (task.isCompleted) {
        completed++;
      } else {
        open++;
      }
      if (task.isDaily) {
        dailyTotal++;
        if (task.isCompleted) {
          dailyCompleted++;
        }
      }
    }

    return TaskSummary(
      completedCount: completed,
      openCount: open,
      dailyTotal: dailyTotal,
      dailyCompleted: dailyCompleted,
    );
  }

  List<MonthlyAllowanceEntry> mesadaPorMes(String childId) {
    const monthNames = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];

    final grouped = <String, double>{};
    final labels = <String, String>{};

    for (final tx in _transactions) {
      if (tx.childId != childId ||
          tx.origem != TransactionSource.mesada ||
          !tx.isCredito) {
        continue;
      }
      final key =
          '${tx.data.year}-${tx.data.month.toString().padLeft(2, '0')}';
      grouped[key] = (grouped[key] ?? 0.0) + tx.valor;
      labels[key] = '${monthNames[tx.data.month - 1]}/${tx.data.year}';
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return sortedKeys
        .map(
          (k) => MonthlyAllowanceEntry(
            monthKey: k,
            monthLabel: labels[k] ?? k,
            total: grouped[k] ?? 0.0,
          ),
        )
        .toList();
  }

  void login(String userId) {
    final found = _users.where((u) => u.id == userId).firstOrNull;
    if (found == null) return;
    _currentUser = found;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void alternarUsuario([String? userId]) {
    if (userId != null) {
      final found = _users.where((u) => u.id == userId).firstOrNull;
      if (found != null) {
        _currentUser = found;
        _isLoggedIn = true;
        notifyListeners();
        return;
      }
    }

    final currentIndex = _users.indexWhere((u) => u.id == _currentUser.id);
    final nextIndex = (currentIndex + 1) % _users.length;
    _currentUser = _users[nextIndex];
    _isLoggedIn = true;
    notifyListeners();
  }

  void cadastrarFilho({
    required String nome,
    required double saldoInicial,
    int? idade,
  }) {
    final newChild = User(
      id: 'child-${DateTime.now().microsecondsSinceEpoch}',
      nome: nome,
      role: UserRole.child,
      avatarSeed: nome.toLowerCase(),
      saldo: saldoInicial,
      idade: idade,
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
          origem: TransactionSource.saldoInicial,
        ),
      );
    }

    notifyListeners();
  }

  void transferirMoedas(
    String childId,
    double valor, {
    String? motivo,
    TransactionSource origem = TransactionSource.mesada,
  }) {
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
        origem: origem,
      ),
    );

    notifyListeners();
  }

  void criarTarefa({
    required String titulo,
    required double recompensa,
    required String atribuidaA,
    TaskFrequency frequencia = TaskFrequency.unica,
  }) {
    final newTask = Task(
      id: 'task-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      recompensa: recompensa,
      status: TaskStatus.pending,
      atribuidaA: atribuidaA,
      frequencia: frequencia,
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
    if (task.status == TaskStatus.completed ||
        task.status == TaskStatus.cancelled) {
      return;
    }

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
          origem: TransactionSource.tarefa,
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

  /// Only the parent/responsible can cancel a pending or waitingApproval task.
  void cancelarTarefaPeloPai(String taskId) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    if (task.isCompleted || task.isCancelled) return;

    _tasks[taskIndex] = task.copyWith(
      status: TaskStatus.cancelled,
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

  void comprarMeta(String goalId) {
    final goalIndex = _goals.indexWhere((g) => g.id == goalId);
    if (goalIndex == -1) return;

    final goal = _goals[goalIndex];
    if (goal.comprado) return;

    final childIndex = _users.indexWhere((u) => u.id == goal.childId);
    if (childIndex == -1) return;

    final childUser = _users[childIndex];
    if (childUser.saldo < goal.valorAlvo) return;

    _users[childIndex] = childUser.copyWith(
      saldo: childUser.saldo - goal.valorAlvo,
    );
    if (_currentUser.id == childUser.id) {
      _currentUser = _users[childIndex];
    }

    _goals[goalIndex] = goal.copyWith(
      comprado: true,
      valorAtual: goal.valorAlvo,
    );

    _transactions.insert(
      0,
      Transaction(
        id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
        titulo: 'Compra: ${goal.titulo}',
        valor: goal.valorAlvo,
        data: DateTime.now(),
        tipo: TransactionType.debito,
        childId: goal.childId,
        origem: TransactionSource.outro,
      ),
    );

    notifyListeners();
  }
}
