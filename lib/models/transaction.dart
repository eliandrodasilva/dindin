enum TransactionType {
  credito,
  debito,
}

enum TransactionSource {
  mesada,
  tarefa,
  saldoInicial,
  outro;

  String get label => switch (this) {
        TransactionSource.mesada => 'Mesada',
        TransactionSource.tarefa => 'Tarefa',
        TransactionSource.saldoInicial => 'Saldo Inicial',
        TransactionSource.outro => 'Outro',
      };
}

class Transaction {
  const Transaction({
    required this.id,
    required this.titulo,
    required this.valor,
    required this.data,
    required this.tipo,
    required this.childId,
    this.origem = TransactionSource.outro,
  });

  final String id;
  final String titulo;
  final double valor;
  final DateTime data;
  final TransactionType tipo;
  final String childId;
  final TransactionSource origem;

  bool get isCredito => tipo == TransactionType.credito;
  bool get isDebito => tipo == TransactionType.debito;
  bool get isMesada => origem == TransactionSource.mesada;
  bool get isTarefa => origem == TransactionSource.tarefa;

  Transaction copyWith({
    String? id,
    String? titulo,
    double? valor,
    DateTime? data,
    TransactionType? tipo,
    String? childId,
    TransactionSource? origem,
  }) {
    return Transaction(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      valor: valor ?? this.valor,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      childId: childId ?? this.childId,
      origem: origem ?? this.origem,
    );
  }
}
