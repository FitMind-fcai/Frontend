class UserEntity {
  final int? id;      // nullable id
  final String name;
  final String email;
  final String password;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });
}
