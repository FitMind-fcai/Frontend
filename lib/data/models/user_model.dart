import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.age,
    required super.email,
    required super.password,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name']??'',
    age: json['age']??  0,
    email: json['email']??  '',
    password: json['password']?? '',
    token: json['token']??  '',
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "age": age,
    "email": email,
    "password": password,
  };
}