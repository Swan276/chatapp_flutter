import 'dart:convert';

import 'package:equatable/equatable.dart';

class RegisterUser extends Equatable {
  const RegisterUser({
    required this.username,
    required this.fullName,
    required this.password,
  });

  final String username;
  final String fullName;
  final String password;

  RegisterUser copyWith({
    String? username,
    String? fullName,
    String? password,
  }) {
    return RegisterUser(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'fullName': fullName,
      'password': password,
    };
  }

  factory RegisterUser.fromMap(Map<String, dynamic> map) {
    return RegisterUser(
      username: map['username'] as String,
      fullName: map['fullName'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterUser.fromJson(String source) =>
      RegisterUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [username, fullName, password];
}
