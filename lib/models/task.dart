enum TaskStatus {
  pending,
  waitingApproval,
  completed,
  cancelled;

  String get code => switch (this) {
        TaskStatus.pending => 'pending',
        TaskStatus.waitingApproval => 'waiting_approval',
        TaskStatus.completed => 'completed',
        TaskStatus.cancelled => 'cancelled',
      };

  String get label => switch (this) {
        TaskStatus.pending => 'Em aguardo',
        TaskStatus.waitingApproval => 'Aguardando confirmação',
        TaskStatus.completed => 'Concluída',
        TaskStatus.cancelled => 'Cancelada',
      };
}

enum TaskFrequency {
  unica,
  diaria,
  semanal;

  String get label => switch (this) {
        TaskFrequency.unica => 'Única',
        TaskFrequency.diaria => 'Diária',
        TaskFrequency.semanal => 'Semanal',
      };
}

class Task {
  const Task({
    required this.id,
    required this.titulo,
    required this.recompensa,
    required this.status,
    required this.atribuidaA,
    this.frequencia = TaskFrequency.unica,
  });

  final String id;
  final String titulo;
  final double recompensa;
  final TaskStatus status;
  final String atribuidaA;
  final TaskFrequency frequencia;

  bool get isPending => status == TaskStatus.pending;
  bool get isWaitingApproval => status == TaskStatus.waitingApproval;
  bool get isCompleted => status == TaskStatus.completed;
  bool get isCancelled => status == TaskStatus.cancelled;
  bool get isActive => isPending || isWaitingApproval;
  bool get isDaily => frequencia == TaskFrequency.diaria;

  Task copyWith({
    String? id,
    String? titulo,
    double? recompensa,
    TaskStatus? status,
    String? atribuidaA,
    TaskFrequency? frequencia,
  }) {
    return Task(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      recompensa: recompensa ?? this.recompensa,
      status: status ?? this.status,
      atribuidaA: atribuidaA ?? this.atribuidaA,
      frequencia: frequencia ?? this.frequencia,
    );
  }
}
