enum UserRole {
  parent,
  child,
}

class User {
  const User({
    required this.id,
    required this.nome,
    required this.role,
    required this.avatarSeed,
    required this.saldo,
    this.idade,
  });

  final String id;
  final String nome;
  final UserRole role;
  final String avatarSeed;
  final double saldo;
  final int? idade;

  bool get isParent => role == UserRole.parent;
  bool get isChild => role == UserRole.child;

  User copyWith({
    String? id,
    String? nome,
    UserRole? role,
    String? avatarSeed,
    double? saldo,
    int? idade,
  }) {
    return User(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      role: role ?? this.role,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      saldo: saldo ?? this.saldo,
      idade: idade ?? this.idade,
    );
  }
}
