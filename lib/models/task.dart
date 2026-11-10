enum TaskStatus {
  pending,
  waitingApproval,
  completed;

  String get code => switch (this) {
        TaskStatus.pending => 'pending',
        TaskStatus.waitingApproval => 'waiting_approval',
        TaskStatus.completed => 'completed',
      };
}

class Task {
  const Task({
    required this.id,
    required this.titulo,
    required this.recompensa,
    required this.status,
    required this.atribuidaA,
  });

  final String id;
  final String titulo;
  final double recompensa;
  final TaskStatus status;
  final String atribuidaA;

  bool get isPending => status == TaskStatus.pending;
  bool get isWaitingApproval => status == TaskStatus.waitingApproval;
  bool get isCompleted => status == TaskStatus.completed;

  Task copyWith({
    String? id,
    String? titulo,
    double? recompensa,
    TaskStatus? status,
    String? atribuidaA,
  }) {
    return Task(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      recompensa: recompensa ?? this.recompensa,
      status: status ?? this.status,
      atribuidaA: atribuidaA ?? this.atribuidaA,
    );
  }
}
