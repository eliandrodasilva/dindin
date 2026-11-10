enum TransactionType {
  credito,
  debito,
}

class Transaction {
  const Transaction({
    required this.id,
    required this.titulo,
    required this.valor,
    required this.data,
    required this.tipo,
    required this.childId,
  });

  final String id;
  final String titulo;
  final double valor;
  final DateTime data;
  final TransactionType tipo;
  final String childId;

  bool get isCredito => tipo == TransactionType.credito;
  bool get isDebito => tipo == TransactionType.debito;

  Transaction copyWith({
    String? id,
    String? titulo,
    double? valor,
    DateTime? data,
    TransactionType? tipo,
    String? childId,
  }) {
    return Transaction(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      valor: valor ?? this.valor,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      childId: childId ?? this.childId,
    );
  }
}
