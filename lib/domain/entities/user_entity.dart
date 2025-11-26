class UserEntity {
  final String name;
  final int age;
  final String email;
  final String password;
  final String? token;

  UserEntity({
    required this.name,
    required this.age,
    required this.email,
    required this.password,
    this.token,
  });
}