class Goal {
  const Goal({
    required this.id,
    required this.titulo,
    required this.valorAlvo,
    required this.valorAtual,
    required this.childId,
  });

  final String id;
  final String titulo;
  final double valorAlvo;
  final double valorAtual;
  final String childId;

  double get progresso =>
      valorAlvo <= 0 ? 0.0 : (valorAtual / valorAlvo).clamp(0.0, 1.0);

  bool get isCompleted => valorAtual >= valorAlvo;

  Goal copyWith({
    String? id,
    String? titulo,
    double? valorAlvo,
    double? valorAtual,
    String? childId,
  }) {
    return Goal(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      valorAlvo: valorAlvo ?? this.valorAlvo,
      valorAtual: valorAtual ?? this.valorAtual,
      childId: childId ?? this.childId,
    );
  }
}
