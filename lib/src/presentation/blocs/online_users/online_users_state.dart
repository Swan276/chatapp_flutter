// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:chatapp_ui/src/data/entities/user.dart';

class OnlineUsersState {
  final List<User>? onlineUsers;
  final String? onlineUsersError;

  OnlineUsersState({
    this.onlineUsers,
    this.onlineUsersError,
  });

  OnlineUsersState copyWith({
    List<User>? onlineUsers,
    String? onlineUsersError,
  }) {
    return OnlineUsersState(
      onlineUsers: onlineUsers ?? this.onlineUsers,
      onlineUsersError: onlineUsersError ?? this.onlineUsersError,
    );
  }

  @override
  bool operator ==(covariant OnlineUsersState other) {
    if (identical(this, other)) return true;

    return listEquals(other.onlineUsers, onlineUsers) &&
        other.onlineUsersError == onlineUsersError;
  }

  @override
  int get hashCode {
    return onlineUsers.hashCode ^ onlineUsersError.hashCode;
  }

  @override
  String toString() {
    return 'OnlineUsersState(onlineUsers: $onlineUsers, onlineUsersError: $onlineUsersError)';
  }
}
