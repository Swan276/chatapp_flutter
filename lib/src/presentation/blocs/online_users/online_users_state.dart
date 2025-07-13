import 'package:equatable/equatable.dart';

import 'package:chatapp_ui/src/data/entities/user.dart';

class OnlineUsersState extends Equatable {
  final List<User>? onlineUsers;
  final List<User>? filteredOnlineUsers;
  final String? onlineUsersError;

  const OnlineUsersState({
    this.onlineUsers,
    this.filteredOnlineUsers,
    this.onlineUsersError,
  });

  OnlineUsersState copyWith({
    List<User>? onlineUsers,
    List<User>? filteredOnlineUsers,
    String? onlineUsersError,
  }) {
    return OnlineUsersState(
      onlineUsers: onlineUsers ?? this.onlineUsers,
      filteredOnlineUsers: filteredOnlineUsers ?? this.filteredOnlineUsers,
      onlineUsersError: onlineUsersError ?? this.onlineUsersError,
    );
  }

  @override
  String toString() {
    return 'OnlineUsersState(onlineUsers: $onlineUsers, filteredOnlineUsers: $filteredOnlineUsers, onlineUsersError: $onlineUsersError)';
  }

  @override
  List<Object?> get props => [
        onlineUsers,
        filteredOnlineUsers,
        onlineUsersError,
      ];
}
