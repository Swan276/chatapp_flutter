// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chatapp_ui/src/data/entities/status.dart';

class User {
  final String nickName;
  final String fullName;
  final Status status;

  User({
    required this.nickName,
    required this.fullName,
    required this.status,
  });

  factory User.online({
    required String nickName,
    required String fullName,
  }) =>
      User(nickName: nickName, fullName: fullName, status: Status.online);

  User copyWith({
    String? nickName,
    String? fullName,
    Status? status,
  }) {
    return User(
      nickName: nickName ?? this.nickName,
      fullName: fullName ?? this.fullName,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nickName': nickName,
      'fullName': fullName,
      'status': status.getName(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      nickName: map['nickName'] as String,
      fullName: map['fullName'] as String,
      status: Status.fromName(map['status'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'User(nickName: $nickName, fullName: $fullName, status: $status)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.nickName == nickName &&
        other.fullName == fullName &&
        other.status == status;
  }

  @override
  int get hashCode => nickName.hashCode ^ fullName.hashCode ^ status.hashCode;
}
