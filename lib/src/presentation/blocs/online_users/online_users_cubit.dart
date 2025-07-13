import 'package:chatapp_ui/src/data/datasources/remote_datasource.dart';
import 'package:chatapp_ui/src/data/datasources/websocket/user_websocket_datasource.dart';
import 'package:chatapp_ui/src/data/entities/status.dart';
import 'package:chatapp_ui/src/data/entities/user.dart';
import 'package:chatapp_ui/src/presentation/blocs/online_users/online_users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlineUsersCubit extends Cubit<OnlineUsersState> {
  OnlineUsersCubit(
    RemoteDatasource remoteDatasource,
    UserWebsocketDatasource userWebsocketDatasource,
    User currentUser,
  )   : _remoteDS = remoteDatasource,
        _userWsDs = userWebsocketDatasource,
        _currentUser = currentUser,
        super(const OnlineUsersState()) {
    _loadOnlineUsers();
  }

  final RemoteDatasource _remoteDS;
  final UserWebsocketDatasource _userWsDs;
  final User _currentUser;

  String? filterKeyword;

  Future<void> refresh() async {
    await _loadOnlineUsers();
  }

  void filterOnlineUsers(String keyword) {
    filterKeyword = keyword;
    if (state.onlineUsers != null) {
      final filteredOnlineUsers =
          _filterWithKeyword(state.onlineUsers!, keyword);
      emit(state.copyWith(filteredOnlineUsers: filteredOnlineUsers));
    }
  }

  Future<void> _loadOnlineUsers() async {
    try {
      final onlineUsers = (await _remoteDS.getOnlineUsers())
          .where((user) => user.username != _currentUser.username)
          .toList();
      _listenUserUpdate();
      emit(
        state.copyWith(
          onlineUsers: onlineUsers,
          filteredOnlineUsers: _filterWithKeyword(
            onlineUsers,
            filterKeyword ?? "",
          ),
          onlineUsersError: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(onlineUsersError: e.toString()));
    }
  }

  void _listenUserUpdate() {
    _userWsDs.userStream.listen(
      (user) {
        final onlineUsers = _updateUser(user);
        final filteredOnlineUsers =
            _filterWithKeyword(onlineUsers, filterKeyword ?? "");

        emit(
          state.copyWith(
            onlineUsers: onlineUsers,
            filteredOnlineUsers: filteredOnlineUsers,
          ),
        );
      },
    );
  }

  List<User> _updateUser(User user) {
    if (state.onlineUsers == null || state.onlineUsers!.isEmpty) {
      return [user];
    }

    var onlineUsers = List<User>.from(state.onlineUsers!);
    onlineUsers.removeWhere((usr) => usr.username == user.username);

    if (user.status == Status.offline) {
      return onlineUsers;
    }
    onlineUsers.add(user);
    return onlineUsers;
  }

  List<User> _filterWithKeyword(List<User> users, String keyword) {
    if (keyword.isEmpty) return users;
    return users
        .where(
          (user) =>
              user.username.contains(keyword) ||
              user.fullName.contains(keyword),
        )
        .toList();
  }
}
